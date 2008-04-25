Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbYDYIHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbYDYIHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYDYIH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:07:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57474
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750894AbYDYIHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:07:25 -0400
Date: Fri, 25 Apr 2008 01:07:24 -0700 (PDT)
Message-Id: <20080425.010724.131751603.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk
Subject: Re: [git pull] scheduler/misc fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080425080421.GA14939@elte.hu>
References: <20080424225530.GA8717@elte.hu>
	<20080424.204620.88617191.davem@davemloft.net>
	<20080425080421.GA14939@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 25 Apr 2008 10:04:21 +0200

> should we perhaps make alloc_bootmem_low() generate a warning instead of 
> breaking the bootup? Especially on systems that have no physical RAM 
> below 4GB at all the whole notion of 'lowmem' is meaningless.

It spits out an error to the console.
