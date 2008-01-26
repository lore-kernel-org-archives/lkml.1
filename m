Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYAZNXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYAZNXy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 08:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYAZNXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 08:23:47 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:54567 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbYAZNXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 08:23:46 -0500
Message-ID: <479B3453.3030105@linux.vnet.ibm.com>
Date: Sat, 26 Jan 2008 18:53:31 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Andy Whitcroft <apw@shadowen.org>,
       Badari Pulavarty <pbadari@us.ibm.com>
Subject: [BUILD FAILURE]2.6.24-git{1,2} kernel powerpc linkage failure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The 2.6.24-git2 kernel build fails on the power boxes with following build failure

  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/powerpc/kernel/built-in.o: In function `fphalf':
arch/powerpc/kernel/vector.S:(.toc+0x1428): undefined reference to `devices_subsys'
make: *** [.tmp_vmlinux1] Error 1

This built-failure was seen in the mm broken-out-2007-11-06-02-32, I have tested 
the patch posted to lkml at http://lkml.org/lkml/2007/11/6/208 fixes this issue.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
