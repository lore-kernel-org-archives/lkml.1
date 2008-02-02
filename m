Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbYBBWuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbYBBWuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 17:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763338AbYBBWt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 17:49:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37843 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762617AbYBBWt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:49:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.24-git7: section mismatches woes
Date: Sat, 2 Feb 2008 23:47:29 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200801301950.44403.rjw@sisk.pl> <200801302232.53306.rjw@sisk.pl> <20080202180828.GC25399@uranus.ravnborg.org>
In-Reply-To: <20080202180828.GC25399@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802022347.29916.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 2 of February 2008, Sam Ravnborg wrote:
> On Wed, Jan 30, 2008 at 10:32:52PM +0100, Rafael J. Wysocki wrote:
> > On Wednesday, 30 of January 2008, Sam Ravnborg wrote:
> > > On Wed, Jan 30, 2008 at 07:50:43PM +0100, Rafael J. Wysocki wrote:
> > > > Hi,
> > > > 
> > > > I get these messages, the majority of which seem to be false-positives:
> > > ...
> > > > modpost: Found 35 section mismatch(es).
> > > > To see additional details select "Enable full Section mismatch analysis"
> > > > in the Kernel Hacking menu (CONFIG_SECTION_MISMATCH).
> > > Looking in to these atm.
> > > 
> > > > 
> > > > and if I compile the kernel with CONFIG_SECTION_MISMATCH, it breaks resuming
> > > > from RAM.
> > > 
> > > The only functional difference when you enable CONFIG_SECTION_MISMATCH is the
> > > addition of the -fno-inline-functions-called-once to CFLAGS.
> > > So we have some code somewhere that breaks if it is not inlined by gcc.
> > > 
> > > It would be nice to sort out where.
> > > If you have a rough idea where to look
> > 
> > No, I don't.
> > 
> > It looks like there's somewhere in arch/x86, since I ruled out kernel/power and
> > drivers/acpi already.
> 
> Hi Rafael.

Hi,

> Do you plan to look closer into this or do you have an easy receipe so
> I can test myself (on a x86 64 bit box)?

Well, I really don't know how to approach this.  Do you have an x86-64 box with
suspend to RAM working?

Rafael
