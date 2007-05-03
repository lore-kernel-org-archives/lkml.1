Return-Path: <linux-kernel-owner+w=401wt.eu-S1767182AbXECU4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767182AbXECU4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767171AbXECU4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:56:37 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:49897 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766620AbXECU4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:56:36 -0400
Date: Thu, 3 May 2007 22:55:49 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Willy Tarreau <w@1wt.eu>
cc: =?iso-8859-1?Q?=D8yvind_V=E5gen_J=E6gtnes?= <lorrides@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Routing 600+ vlan's via linux problems (looks like arp problems)
In-Reply-To: <20070503205341.GB943@1wt.eu>
Message-ID: <Pine.LNX.4.61.0705032255080.18504@yvahk01.tjqt.qr>
References: <d20c3b7d0705031325r13834382r38ea31f26965c50@mail.gmail.com>
 <20070503205341.GB943@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 3 2007 22:53, Willy Tarreau wrote:
>> For the rest all we see in the arp cache is (incomplete)
>
>I suspect that your arp cache is full (128 entries by default).
>Check /proc/sys/net/ipv4/neigh/gc_thresh1 (128 for me). You can
>set it as high as gc_thresh2 (512 for me), and I don't know what
>happens above.

Above, you will perhaps need the not-so-elegant userspace arpd :-/


Jan
-- 
