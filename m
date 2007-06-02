Return-Path: <linux-kernel-owner+w=401wt.eu-S1762498AbXFBVrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762498AbXFBVrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 17:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757053AbXFBVrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 17:47:33 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:39745 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671AbXFBVrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 17:47:32 -0400
Date: Sat, 2 Jun 2007 23:46:46 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Netfilter Mailing List <netfilter@lists.netfilter.org>,
       Netfilter Developer Mailing List 
	<netfilter-devel@lists.netfilter.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] xt_u32 - match arbitrary bits and bytes of a packet
Message-ID: <Pine.LNX.4.61.0706022322340.28357@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!


along comes xt_u32, a revamped ipt_u32,

    *	added ipv6 support since that seemed dead simple, given u32's 
	task. I would have even liked to unlock u32 for _all_ protocols, 
	but .family = AF_UNSPEC does not do the right thing right now, 
	but that's not so much a showstopper.

	And arptables seems miles away from using iptables modules. So
	AF_INET and AF_INET6 it is for now.

    *	Reduced the buffer size to 17 KB. I think that is quite ok since 
	I added an overflow check,  SHOULD THERE BE ANY device with an 
	MTU larger than our loopback masterpiece (16436 bytes).

	Are there such devices that support Megasuperjumboframes?
	The previous buffer size of 64 KB was probably the cutting edge,
	as a single IPv4 fragment/packet does not support more than that 
	anyway.


Questions, comments, blame, praise, please.
I'd like to get this merged so I do not have to maintain it out-of-tree.


	Jan
-- 
