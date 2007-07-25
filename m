Return-Path: <linux-kernel-owner+w=401wt.eu-S935066AbXGYSf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935066AbXGYSf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXGYSfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:35:19 -0400
Received: from mx1.aecom.yu.edu ([129.98.1.51]:39939 "EHLO mx1.aecom.yu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbXGYSfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:35:18 -0400
X-Greylist: delayed 1181 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jul 2007 14:35:18 EDT
X-AuditID: 816201a0-a0e23bb000007886-45-46a790e9dc64 
Mime-Version: 1.0
Message-Id: <a06240421c2cd420bb671@[129.98.90.227]>
Date: Wed, 25 Jul 2007 14:14:21 -0400
To: jheffner@psc.edu
From: Maurice Volaski <mvolaski@aecom.yu.edu>
Subject: Re: drbd 8.0.2/3 doesn't load under kernel 2.6.21
Cc: discussion@web100.aecom.yu.edu, linux-kernel@vger.kernel.org,
       drbd-user@linbit.com
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John,

What's story with this? I just tried the patch for 2.6.22 and your 
patch is still trashing the kernel, preventing drbd from being 
compiled in.

Anyone else have any idea how these apparently simple network patches 
could render these symbols inaccessible to the kernel?


>It turns out I was adding the web100 patch (http://www.web100.org) to
>the 2.6.21 kernel and that's what causes the symbol resolving problem
>below. Adding the corresponding version of the web100 patch to the
>2.6.20 kernel makes this problem appear there as well. On fresh
>versions of the kernel, this problem does not occur. At the moment,
>it's not possible to have a current kernel that contains both drbd
>and web100.
>
>>On a 64-bit Gentoo system with Gentoo's 2.6.21 kernel, drbd 8.0.2/3
>>complains when I try to load the module:
>>
>>[  134.141363] drbd: Unknown symbol cn_fini
>>[  134.141399] drbd: Unknown symbol cn_init
>>
>>It works fine when I compile it and load in the previous kernel
>>version, 2.6.20 and the symbols are present in the map file
>>
>>./System.map-genkernel-x86_64-2.6.21-gentoo-r2:ffffffff802935aa t cn_fini
>>./System.map-genkernel-x86_64-2.6.21-gentoo-r2:ffffffff8029362a t cn_init
>>
>>I am c'cing the kernel mailing list because this appears to be a
>>problem with how any module accesses symbols in the kernel, not just
>  >drbd. Source was compiled with Gentoo gcc-4.1.2, glibc-2.5-r3

-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
