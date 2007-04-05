Return-Path: <linux-kernel-owner+w=401wt.eu-S1161179AbXDEFC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161179AbXDEFC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 01:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161184AbXDEFC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 01:02:57 -0400
Received: from gw.goop.org ([64.81.55.164]:43263 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161179AbXDEFC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 01:02:56 -0400
Message-Id: <20070405045825.511024444@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Apr 2007 21:58:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [patch 0/2] Updates to compat VDSOs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Here's a couple of patches to fix up COMPAT_VDSO:

The first is a straightforward implementation of Jan's original idea
of relocating the VDSO to match its mapped location.  Unlike Jan and
Zach's version, I changed it to relocate based on the phdrs rather than
the sections; the result is pleasantly compact.

The second patch takes advantage of the fact that all the COMPAT_VDSO work
happens at runtime now, and allows compat mode to be enabled dynamically.
If you specify vdso=2 on the kernel command line, it comes up in compat
mode; vdso=1 is normal vdso mode, and vdso=0 disables vdso altogether.
You can also switch modes with sysctl.

Thanks,
	J

-- 

