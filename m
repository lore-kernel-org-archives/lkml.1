Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbXFLVJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbXFLVJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 17:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbXFLVJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 17:09:07 -0400
Received: from mx1.aecom.yu.edu ([129.98.1.51]:35947 "EHLO mx1.aecom.yu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbXFLVJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 17:09:07 -0400
X-Greylist: delayed 1365 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jun 2007 17:09:06 EDT
X-AuditID: 816201a0-9c0cabb0000059a0-6c-466f047eaaed 
Mime-Version: 1.0
Message-Id: <a06240416c294a99407c3@[129.98.90.227]>
In-Reply-To: <20070612191821.BDB302E0787B@mail.linbit.com>
References: <20070612191821.BDB302E0787B@mail.linbit.com>
Date: Tue, 12 Jun 2007 16:45:56 -0400
To: drbd-user@linbit.com
From: Maurice Volaski <mvolaski@aecom.yu.edu>
Subject: drbd 8.0.2/3 doesn't load under kernel 2.6.21
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On a 64-bit Gentoo system with Gentoo's 2.6.21 kernel, drbd 8.0.2/3 
complains when I try to load the module:

[  134.141363] drbd: Unknown symbol cn_fini
[  134.141399] drbd: Unknown symbol cn_init

It works fine when I compile it and load in the previous kernel 
version, 2.6.20 and the symbols are present in the map file

./System.map-genkernel-x86_64-2.6.21-gentoo-r2:ffffffff802935aa t cn_fini
./System.map-genkernel-x86_64-2.6.21-gentoo-r2:ffffffff8029362a t cn_init

I am c'cing the kernel mailing list because this appears to be a 
problem with how any module accesses symbols in the kernel, not just 
drbd. Source was compiled with Gentoo gcc-4.1.2, glibc-2.5-r3.
-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
