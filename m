Return-Path: <linux-kernel-owner+w=401wt.eu-S932214AbYD1Ghy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbYD1Ghy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbYD1Ghl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:37:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34824
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755301AbYD1Ghk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:37:40 -0400
Date: Sun, 27 Apr 2008 23:37:40 -0700 (PDT)
Message-Id: <20080427.233740.208119217.davem@davemloft.net>
To: hch@infradead.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080428062935.GA13876@infradead.org>
References: <20080427.170139.242528272.davem@davemloft.net>
	<20080428062935.GA13876@infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Mon, 28 Apr 2008 02:29:35 -0400

> Is a WARN_ON the right check for user-triggerable behaviour?  I think
> a normal rate-limited printk with a descriptive text would be better.

I used WARN_ON_ONCE, which I think is sufficient.
