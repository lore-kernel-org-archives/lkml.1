Return-Path: <linux-kernel-owner+w=401wt.eu-S1763035AbXFCIVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763035AbXFCIVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 04:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbXFCIVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 04:21:48 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:59433 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbXFCIVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 04:21:47 -0400
Date: Sun, 3 Jun 2007 10:20:13 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Valdis.Kletnieks@vt.edu
cc: Netfilter Mailing List <netfilter@lists.netfilter.org>,
       Netfilter Developer Mailing List 
	<netfilter-devel@lists.netfilter.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] xt_u32 - match arbitrary bits and bytes of a packet
In-Reply-To: <18087.1180847247@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.61.0706031007320.10578@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706022322340.28357@yvahk01.tjqt.qr>
 <18087.1180847247@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 3 2007 01:07, Valdis.Kletnieks@vt.edu wrote:
>On Sat, 02 Jun 2007 23:46:46 +0200, Jan Engelhardt said:
>
>> along comes xt_u32, a revamped ipt_u32,
>
>+1 for doing this - I've been dragging along a local ipt_u32 patch for a while,
>and been wishing it had ipv6 support.
>
>>     *	Reduced the buffer size to 17 KB. I think that is quite ok since 
>> 	I added an overflow check,  SHOULD THERE BE ANY device with an 
>> 	MTU larger than our loopback masterpiece (16436 bytes).
>> 
>> 	Are there such devices that support Megasuperjumboframes?
>
>IP over Infiniband? I think those have some outrageous MTU?  Personally,
>I wouldn't need it for anything bigger than 9K ethernet jumbograms, but
>that one's a decision for others.

Can you find out? For such supersize packets, I'd like to switch to
kmalloc/vmalloc rather than keeping a big buffer in the .bss.


	Jan
-- 
