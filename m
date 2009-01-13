Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbZAMLXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbZAMLXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 06:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZAMLXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 06:23:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49452 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbZAMLXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 06:23:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: 2.6.29-rc1: Reported regressions from 2.6.28
Date: Tue, 13 Jan 2009 12:23:01 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera> <200901112001.00394.rjw@sisk.pl> <3f9a31f40901121924v86b528er652b27e670c5fe0@mail.gmail.com>
In-Reply-To: <3f9a31f40901121924v86b528er652b27e670c5fe0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131223.02813.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2009, Jaswinder Singh Rajput wrote:
> Hello Rafael,
> 
> On Mon, Jan 12, 2009 at 12:30 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday 11 January 2009, Ingo Molnar wrote:
> >>
> >> * Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
> >>
> >> > On Sun, Jan 11, 2009 at 4:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > >
> >> > > Regressions with patches
> >> > > ------------------------
> >> > >
> >> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12428
> >> > > Subject         : Build error on latest git
> >> > > Submitter       : Petr Titera <P.Titera@century.cz>
> >> > > Date            : 2009-01-11 9:49 (1 days old)
> >> > > References      : http://marc.info/?l=linux-kernel&m=123166856318712&w=4
> >> > > Handled-By      : Petr Titera <P.Titera@century.cz>
> >> > > Patch           : http://marc.info/?l=linux-kernel&m=123167509024996&w=4
> >> >
> >> > This is a wrong fix, asm/smp.h should only be included when CONFIG_SMP
> >> > is defined.
> >> >
> >> > I am still in the process of cleaning non-smp data from asm/smp.h for
> >> > x86
> >> >
> >> > Attach patch is the solution for the time being
> >> >
> >> > Ingo, can you please put this in urgent queue.
> >>
> >> yes, it already is - see below.
> >
> > Link to this patch was added to the bug entry.  Pleaes let me know or close the
> > bug when it's merged.
> >
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4884d8e6a05026ec906355436cea9dc1acb1d09e

Thanks, the bug has been closed.

Rafael
