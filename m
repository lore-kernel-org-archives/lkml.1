Return-Path: <linux-kernel-owner+w=401wt.eu-S1761447AbYD3HwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761447AbYD3HwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757455AbYD3HwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:52:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38191
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757285AbYD3HwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:52:13 -0400
Date: Wed, 30 Apr 2008 00:52:12 -0700 (PDT)
Message-Id: <20080430.005212.46815036.davem@davemloft.net>
To: mingo@elte.hu
Cc: mchehab@infradead.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
Subject: Re: [patch, -git] drivers/media build fix for modular builds
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080430074807.GA11224@elte.hu>
References: <20080429185009.716c3284@gaivota>
	<20080430074807.GA11224@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 30 Apr 2008 09:48:07 +0200

> 
> fix allmodconfig build bug introduced in latest -git by commit 
> 7c91f0624a9 ("V4L/DVB(7767): Move tuners to common/tuners"):
> 
>   LD      kernel/built-in.o
>   LD      drivers/built-in.o
>   ld: drivers/media/built-in.o: No such file: No such file or directory
> 
> which happens if all media drivers are modular:

I was seeing this too, as I think was Stephen Rothwell.
