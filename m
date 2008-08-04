Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbYHDWjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbYHDWjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbYHDWiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:38:52 -0400
Received: from over.ny.us.ibm.com ([32.97.182.150]:55608 "EHLO
	over.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbYHDWiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:38:51 -0400
Subject: Re: Checkpatch false positive?
From: Matt Helsley <matthltc@us.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080803221804.GA5972@brain>
References: <1217566262.25300.188.camel@localhost.localdomain>
	 <20080803221804.GA5972@brain>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Mon, 04 Aug 2008 15:10:44 -0700
Message-Id: <1217887844.9358.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-08-03 at 23:18 +0100, Andy Whitcroft wrote:
> On Thu, Jul 31, 2008 at 09:51:02PM -0700, Matthew Helsley wrote:
> > Hello checkpatch.pl maintainers,
> > 
> > 	I'm adding a new thread flag and I get this apparent checkpatch false
> > positive:
> > 
> > 
> > ERROR: do not modify files in include/asm, change architecture specific files in include/asm-<architecture>
> > #36: +++ linux-2.6.27-rc1-mm1/arch/sparc/include/asm/thread_info_32.h
> > 
> > ERROR: do not modify files in include/asm, change architecture specific files in include/asm-<architecture>
> > #63: +++ linux-2.6.27-rc1-mm1/arch/sparc/include/asm/thread_info_64.h
> > 
> > ERROR: do not modify files in include/asm, change architecture specific files in include/asm-<architecture>
> > #289: +++ linux-2.6.27-rc1-mm1/arch/parisc/include/asm/thread_info.h
> > 
> > patches/0001-Container-Freezer-Add-TIF_FREEZE-flag-to-all-archit.patch total: 3 errors, 0 warnings, 214 lines checked
> > 
> > patches/0001-Container-Freezer-Add-TIF_FREEZE-flag-to-all-archit.patch has style problems, please review.  If any of these errors
> > are false positives report them to the maintainer, see
> > CHECKPATCH in MAINTAINERS.
> > 
> > 
> > 	Which happens for every arch where the file has been moved under the
> > arch/ directory (sparc and parisc so far). Should this check for
> > arch/<foo>/include/asm before giving an ERROR? Should
> > arch/<foo>/include/asm only trigger a WARNING in this case?
> > 
> > Cheers,
> > 	-Matt Helsley
> 
> Yes, that check isn't very well anchored.  I've tightened that up in the
> latest version.  Could you check your patch with the latest testing
> version for me:
> 
>     http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing
> 
> -apw

Output looks good:

patches/0001-Container-Freezer-Add-TIF_FREEZE-flag-to-all-archit.patch
total: 0 errors, 0 warnings, 152 lines checked

patches/0001-Container-Freezer-Add-TIF_FREEZE-flag-to-all-archit.patch
has no obvious style problems and is ready for submission.


Thanks!

Cheers,
	-Matt Helsley

