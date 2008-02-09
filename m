Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYBILHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYBILHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 06:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYBILHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 06:07:05 -0500
Received: from www.tglx.de ([62.245.132.106]:51668 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbYBILHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 06:07:03 -0500
Date: Sat, 9 Feb 2008 12:06:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prakash Punnoor <prakash@punnoor.de>
cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
In-Reply-To: <200802090008.05430.prakash@punnoor.de>
Message-ID: <alpine.LFD.1.00.0802091140170.3145@apollo.tec.linutronix.de>
References: <20080207195519.GA21772@basil.nowhere.org> <200802082000.39919.prakash@punnoor.de> <20080208210258.GA13058@one.firstfloor.org> <200802090008.05430.prakash@punnoor.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008, Prakash Punnoor wrote:

> On the day of Friday 08 February 2008 Andi Kleen hast written:
> > On Fri, Feb 08, 2008 at 08:00:39PM +0100, Prakash Punnoor wrote:
> > > On the day of Friday 08 February 2008 Andi Kleen hast written:
> > > > On Fri, Feb 08, 2008 at 06:39:17PM +0100, Prakash Punnoor wrote:
> > > > >
> > > > > Yes, confirmed. timer w/o the skipping stays XT-PIC on nforce2.
> > > >
> > > > Confirmed what? Did you test my patch on both machines?
> > > > What was the result?
> > >
> > > I confirmed that it (nforce2) needed the acpi_skip_timer_override. If you
> > > read my mail, you knew I didn't test your patch.
> >
> > Ok can you please do so then?  Or stop your obstructism?
> 
> Grr, I don't know why I am discussing with stubborn and/or arrogant devs like 
> you seem to be. But I actually did what you wanted and as *expected* - as I 
> said I understand that trivial piece of code you posted - your patch fails 
> here for my nforce2:

No worry, this patch wont go anywhere near mainline as long as it
breaks stuff and obviously you are under no obligation to re-test
patches that have not been changed just re-submitted.

x86 changes, which are considered for mainline are staged in the mm
branch of the x86 git tree:

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=shortlog;h=mm

Instructions for checking it out are here:
http://people.redhat.com/mingo/x86.git/README

Please let us know, if there is anything which breaks your box(en).

Thanks for your feedback and patience.

	tglx
