Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbXHAUX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbXHAUX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXHAUXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:23:20 -0400
Received: from mx1.aecom.yu.edu ([129.98.1.51]:44428 "EHLO mx1.aecom.yu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbXHAUXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:23:19 -0400
X-AuditID: 816201a0-9b39cbb000007c32-2b-46b0e93a7c36 
Mime-Version: 1.0
Message-Id: <a0624045cc2d691fb7294@[129.98.90.227]>
Date: Wed, 1 Aug 2007 16:21:29 -0400
To: jheffner@psc.edu
From: Maurice Volaski <mvolaski@aecom.yu.edu>
Subject: Re: drbd 8.0.2/3 doesn't load under kernel 2.6.21
Cc: discussion@web100.org, linux-kernel@vger.kernel.org, drbd-user@linbit.com
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm making an assumption that depmod is somehow to blame and have 
logged this as a kernel bug, 
http://bugzilla.kernel.org/show_bug.cgi?id=8829

>
>>It turns out I was adding the web100 patch (http://www.web100.org) to
>>the 2.6.21 kernel and that's what causes the symbol resolving problem
>>below. Adding the corresponding version of the web100 patch to the
>>2.6.20 kernel makes this problem appear there as well. On fresh
>>versions of the kernel, this problem does not occur. At the moment,
>>it's not possible to have a current kernel that contains both drbd
>>and web100.
>>
>>>On a 64-bit Gentoo system with Gentoo's 2.6.21 kernel, drbd 8.0.2/3
>>>complains when I try to load the module:
>>>
>>>[  134.141363] drbd: Unknown symbol cn_fini
>>>[  134.141399] drbd: Unknown symbol cn_init
>>>
>>>It works fine when I compile it and load in the previous kernel
>>>version, 2.6.20 and the symbols are present in the map file
>>>
>>>./System.map-genkernel-x86_64-2.6.21-gentoo-r2:ffffffff802935aa t cn_fini
>>>./System.map-genkernel-x86_64-2.6.21-gentoo-r2:ffffffff8029362a t cn_init
>>>
>>>I am c'cing the kernel mailing list because this appears to be a
>>>problem with how any module accesses symbols in the kernel, not just
>>  >drbd. Source was compiled with Gentoo gcc-4.1.2, glibc-2.5-r3

-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
