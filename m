Return-Path: <linux-kernel-owner+w=401wt.eu-S1765337AbYETSgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765337AbYETSgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbYETSfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:35:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234AbYETSfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:35:52 -0400
Date: Tue, 20 May 2008 14:06:09 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Remove unnecessary code in 64bit CPU identification.
Message-ID: <20080520180609.GA31805@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <200805200409.m4K49ZuE024343@gelk.kernelslacker.org> <4832E461.2070503@zytor.com> <20080520151655.GA542@redhat.com> <4833112F.7020402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4833112F.7020402@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 10:58:07AM -0700, H. Peter Anvin wrote:
 > Dave Jones wrote:
 > > On Tue, May 20, 2008 at 07:46:57AM -0700, H. Peter Anvin wrote:
 > >  > Dave Jones wrote:
 > >  > > There were no 64bit Transmeta CPUs made (and it'd be something of
 > >  > > a surprise if they started any time soon).   To the best of my knowledge,
 > >  > > no CPU vendor cloned the 80860000 cpuid space claimed by Transmeta.
 > >  > > By removing this code, we can also eliminate calling cpuid 0x80000007 twice.
 > >  > > 
 > >  > > Signed-off-by: Dave Jones <davej@redhat.com>
 > >  > 
 > >  > I'd really like to avoid divergences between the 32-bit and 64-bit code 
 > >  > if they can be avoided at this point.  These codes need to be unified, 
 > >  > not further split.
 > > 
 > > Umm, the 32 bit code has the per-vendor stuff removed from setup.c, and factored
 > > out into per-vendor files in arch/x86/kernel/cpu/  Because the 64bit version
 > > doesn't do that (yet), my removal of this code actually gets us closer to unification.
 > > After my patch, neither of the setup.c files have the Transmeta bits :)
 > > 
 > 
 > *Shrug* ... it seems like pointless churn to code that really needs to 
 > die to me.

setup_64.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

It's a slow death, but it's easier to chip away at the obvious parts..

	Dave

-- 
http://www.codemonkey.org.uk
