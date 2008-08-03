Return-Path: <linux-kernel-owner+w=401wt.eu-S1760162AbYHCWSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162AbYHCWSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 18:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbYHCWSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 18:18:09 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:60903 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793AbYHCWSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 18:18:08 -0400
Date: Sun, 3 Aug 2008 23:18:04 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Matthew Helsley <matthltc@us.ibm.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Checkpatch false positive?
Message-ID: <20080803221804.GA5972@brain>
References: <1217566262.25300.188.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217566262.25300.188.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 09:51:02PM -0700, Matthew Helsley wrote:
> Hello checkpatch.pl maintainers,
> 
> 	I'm adding a new thread flag and I get this apparent checkpatch false
> positive:
> 
> 
> ERROR: do not modify files in include/asm, change architecture specific files in include/asm-<architecture>
> #36: +++ linux-2.6.27-rc1-mm1/arch/sparc/include/asm/thread_info_32.h
> 
> ERROR: do not modify files in include/asm, change architecture specific files in include/asm-<architecture>
> #63: +++ linux-2.6.27-rc1-mm1/arch/sparc/include/asm/thread_info_64.h
> 
> ERROR: do not modify files in include/asm, change architecture specific files in include/asm-<architecture>
> #289: +++ linux-2.6.27-rc1-mm1/arch/parisc/include/asm/thread_info.h
> 
> patches/0001-Container-Freezer-Add-TIF_FREEZE-flag-to-all-archit.patch total: 3 errors, 0 warnings, 214 lines checked
> 
> patches/0001-Container-Freezer-Add-TIF_FREEZE-flag-to-all-archit.patch has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> 
> 
> 	Which happens for every arch where the file has been moved under the
> arch/ directory (sparc and parisc so far). Should this check for
> arch/<foo>/include/asm before giving an ERROR? Should
> arch/<foo>/include/asm only trigger a WARNING in this case?
> 
> Cheers,
> 	-Matt Helsley

Yes, that check isn't very well anchored.  I've tightened that up in the
latest version.  Could you check your patch with the latest testing
version for me:

    http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

-apw
