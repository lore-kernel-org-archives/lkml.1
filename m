Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbZFECAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbZFECAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 22:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZFECAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 22:00:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:33336 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbZFECAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 22:00:13 -0400
Subject: Re: [PATCH 0/6] headers_check fix patches 20090604
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Russell King <rmk+lkml@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, Ralf Baechle <ralf@linux-mips.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <20090604201242.GB13892@uranus.ravnborg.org>
References: <1244118232.5172.26.camel@ht.satnam>
	 <20090604201242.GB13892@uranus.ravnborg.org>
Content-Type: text/plain
Date: Fri, 05 Jun 2009 07:30:15 +0530
Message-Id: <1244167215.2522.7.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

On Thu, 2009-06-04 at 22:12 +0200, Sam Ravnborg wrote:
> On Thu, Jun 04, 2009 at 05:53:52PM +0530, Jaswinder Singh Rajput wrote:
> > Please Review :
> > 
> > Jaswinder Singh Rajput (6):
> >       headers_check fix: arm, hwcap.h
> >       headers_check fix: ia64, fpswa.h
> >       headers_check fix: m68k, swab.h
> >       headers_check fix: mips, ioctl.h
> >       headers_check fix: mn10300, ptrace.h
> >       headers_check fix: mn10300, setup.h
> 
> Please let the subject explain what was fixed.
> The fact that you used headers_check to detect the
> issue in the first place is less relevant.
> 
> For mips the subject could have been:
> 
> mips: use userspace compatible definition of _IOC_TYPECHECK
> 

OK, BTW I pointed this in commit log.

> Did you concentrate solely on headers_check output
> or did you carefully inspect the files you touched for userspace issues?
> I stroingly recommend to fix all userspace issues in files touched
> if this is possible.
> 

I did my best and fix all userspace issues in above files. Now I am
waiting for the review from maintainers.

Thanks,
--
JSR

