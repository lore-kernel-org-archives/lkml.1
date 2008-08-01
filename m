Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYHAEvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYHAEvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 00:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYHAEvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 00:51:04 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52624 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbYHAEvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 00:51:02 -0400
Subject: Checkpatch false positive?
From: Matthew Helsley <matthltc@us.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 21:51:02 -0700
Message-Id: <1217566262.25300.188.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello checkpatch.pl maintainers,

	I'm adding a new thread flag and I get this apparent checkpatch false
positive:


ERROR: do not modify files in include/asm, change architecture specific files in include/asm-<architecture>
#36: +++ linux-2.6.27-rc1-mm1/arch/sparc/include/asm/thread_info_32.h

ERROR: do not modify files in include/asm, change architecture specific files in include/asm-<architecture>
#63: +++ linux-2.6.27-rc1-mm1/arch/sparc/include/asm/thread_info_64.h

ERROR: do not modify files in include/asm, change architecture specific files in include/asm-<architecture>
#289: +++ linux-2.6.27-rc1-mm1/arch/parisc/include/asm/thread_info.h

patches/0001-Container-Freezer-Add-TIF_FREEZE-flag-to-all-archit.patch total: 3 errors, 0 warnings, 214 lines checked

patches/0001-Container-Freezer-Add-TIF_FREEZE-flag-to-all-archit.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.


	Which happens for every arch where the file has been moved under the
arch/ directory (sparc and parisc so far). Should this check for
arch/<foo>/include/asm before giving an ERROR? Should
arch/<foo>/include/asm only trigger a WARNING in this case?

Cheers,
	-Matt Helsley

