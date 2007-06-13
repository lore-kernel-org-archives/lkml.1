Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbXFMDiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbXFMDiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 23:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbXFMDio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 23:38:44 -0400
Received: from mx1.aecom.yu.edu ([129.98.1.51]:33314 "EHLO mx1.aecom.yu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbXFMDin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 23:38:43 -0400
X-AuditID: 816201a0-9986abb0000059a0-6a-466f65238e1a 
Mime-Version: 1.0
Message-Id: <a0624041ac294d93a32bc@[129.98.90.227]>
Date: Tue, 12 Jun 2007 23:38:17 -0400
To: discussion@web100.org
From: Maurice Volaski <mvolaski@aecom.yu.edu>
Subject: Re: drbd 8.0.2/3 doesn't load under kernel 2.6.21
Cc: drbd-user@linbit.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out I was adding the web100 patch (http://www.web100.org) to 
the 2.6.21 kernel and that's what causes the symbol resolving problem 
below. Adding the corresponding version of the web100 patch to the 
2.6.20 kernel makes this problem appear there as well. On fresh 
versions of the kernel, this problem does not occur. At the moment, 
it's not possible to have a current kernel that contains both drbd 
and web100.

>On a 64-bit Gentoo system with Gentoo's 2.6.21 kernel, drbd 8.0.2/3 
>complains when I try to load the module:
>
>[  134.141363] drbd: Unknown symbol cn_fini
>[  134.141399] drbd: Unknown symbol cn_init
>
>It works fine when I compile it and load in the previous kernel 
>version, 2.6.20 and the symbols are present in the map file
>
>./System.map-genkernel-x86_64-2.6.21-gentoo-r2:ffffffff802935aa t cn_fini
>./System.map-genkernel-x86_64-2.6.21-gentoo-r2:ffffffff8029362a t cn_init
>
>I am c'cing the kernel mailing list because this appears to be a 
>problem with how any module accesses symbols in the kernel, not just 
>drbd. Source was compiled with Gentoo gcc-4.1.2, glibc-2.5-r3.

-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
