Return-Path: <linux-kernel-owner+w=401wt.eu-S933863AbYBBSIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863AbYBBSIh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 13:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYBBSI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 13:08:27 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:33533 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbYBBSIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 13:08:25 -0500
Date: Sat, 2 Feb 2008 19:08:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-git7: section mismatches woes
Message-ID: <20080202180828.GC25399@uranus.ravnborg.org>
References: <200801301950.44403.rjw@sisk.pl> <20080130190829.GA25490@uranus.ravnborg.org> <200801302232.53306.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801302232.53306.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 10:32:52PM +0100, Rafael J. Wysocki wrote:
> On Wednesday, 30 of January 2008, Sam Ravnborg wrote:
> > On Wed, Jan 30, 2008 at 07:50:43PM +0100, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > I get these messages, the majority of which seem to be false-positives:
> > ...
> > > modpost: Found 35 section mismatch(es).
> > > To see additional details select "Enable full Section mismatch analysis"
> > > in the Kernel Hacking menu (CONFIG_SECTION_MISMATCH).
> > Looking in to these atm.
> > 
> > > 
> > > and if I compile the kernel with CONFIG_SECTION_MISMATCH, it breaks resuming
> > > from RAM.
> > 
> > The only functional difference when you enable CONFIG_SECTION_MISMATCH is the
> > addition of the -fno-inline-functions-called-once to CFLAGS.
> > So we have some code somewhere that breaks if it is not inlined by gcc.
> > 
> > It would be nice to sort out where.
> > If you have a rough idea where to look
> 
> No, I don't.
> 
> It looks like there's somewhere in arch/x86, since I ruled out kernel/power and
> drivers/acpi already.

Hi Rafael.

Do you plan to look closer into this or do you have an easy receipe so
I can test myself (on a x86 64 bit box)?

	Sam
