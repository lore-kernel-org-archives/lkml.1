Return-Path: <linux-kernel-owner+w=401wt.eu-S1765868AbXKOWYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765868AbXKOWYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:24:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763500AbXKOWXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:23:50 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41032 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761621AbXKOWXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:23:48 -0500
X-Sasl-enc: WksBF2EVLoM7QHKYtfY/kpf4/X/7pXvlMJmN+4nHI236 1195165427
Message-ID: <1ddf01c827d6$40106500$0a01a8c0@robmhp>
From: "Rob Mueller" <robm@fastmail.fm>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Cc: "Bron Gondwana" <brong@fastmail.fm>,
       "Christian Kujau" <lists@nerdbynature.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "riel" <riel@redhat.com>, "Anton Altaparmakov" <aia21@cam.ac.uk>
References: <20071113.043207.44732743.davem@davemloft.net>  <20071113110259.44c56d42.akpm@linux-foundation.org>  <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de>  <20071113130411.26ccae12.akpm@linux-foundation.org>  <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de>  <20071115040708.GB15302@brong.net>  <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>  <20071115052538.GA21522@brong.net>  <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org>  <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>  <20071115115049.GA8297@brong.net>  <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org>  <1195155601.22457.25.camel@lappy> <1195159457.22457.35.camel@lappy>  <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org>  <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org> <1195162015.22457.52.camel@lappy> <alpine.LFD.0.9999.0711151342100.4260@woody.linux-foundation.org>
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel Bugs)
Date: Fri, 16 Nov 2007 09:24:06 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> That's my personal opinion, and I realize that some of the commercial
> vendors may care about their insane customers' satisfaction, but I'm
> simply not interested in insane users. If they have that much RAM (and
> bought it a few years ago when a 64-bit CPU wasn't an option), they can't
> be poor.

>From our perspective, the main issue is that some of these machines we spent 
quite a bit of money on the big RAM (for it's day) + lots of 15k RPM SCSI 
drives + multi-year support contracts. They're highly IO bound, and barely 
use 10-20% of their old 2.4Ghz Prestonia Xeon CPUs. It's hard to justify 
junking those machines < 5 years.

We have a couple of 6G machines and some 8G machines using PAE. On the 
whole, they actually have been working really well (hmmm, apart from the 
recent dirty pages issue + reiserfs data=journal leaks + inodes in lowmem 
limits)

Rob

