Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbZGJNHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbZGJNHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 09:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZGJNHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 09:07:48 -0400
Received: from www.tglx.de ([62.245.132.106]:59026 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbZGJNHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 09:07:47 -0400
Date: Fri, 10 Jul 2009 15:05:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Fisher <bug-track@fisher-privat.net>
cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Richard A. Holden III" <aciddeath@gmail.com>
Subject: Re: Intel BIOS - Corrupted low memory at ffff880000004200
In-Reply-To: <4A573131.40601@fisher-privat.net>
Message-ID: <alpine.LFD.2.00.0907101504030.2768@localhost.localdomain>
References: <4A5210A2.2080301@fisher-privat.net> <4A52254F.8080103@fisher-privat.net> <20090708113949.GA8960@srcf.ucam.org> <20090710115238.GA8812@elte.hu> <4A573131.40601@fisher-privat.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009, Alexey Fisher wrote:
> Ingo Molnar schrieb:
> > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > 
> > > On Mon, Jul 06, 2009 at 06:24:47PM +0200, Alexey Fisher wrote:
> > > > Hallo Ingo, Richard.
> > > > 
> > > > I'm getting "Corrupted low memory" trace with my Intel DG45ID board
> > > > after resume. This board has different dmi-bios-vendor... so probably it
> > > > will be nice to have it in your patch.
> > > I'm beginning to think that we should be doing this on all hardware,
> > > perhaps with a kernel option to disable it for embedded devices that
> > > really need that 64K. The low-memory corruption issue seems to be very
> > > widespread.
> > 
> > The problem is that the BIOS corrupted memory that it also marked as
> > 'usable' in its E820 map it gave to the kernel. If that memory is not
> > usable, it should not have been marked as such. Also, some of the reports
> > showed corruption beyond this range so the workaround is not universal.
> > 
> > So i'd really like to know what is happening there, instead of just zapping
> > support for 64K of RAM on the majority of Linux systems.
> > 
> > We might end up doing the same thing in the end (i.e. disable that 64k of
> > RAM) - but it should be an informed decision, not a wild stab in the dark.
> > 
> > 	Ingo
> 
> If i make memory dump like "dd if=/dev/mem of=memdump.dd bs=64k count=1"
> before and after suspend. Will it help you find out whats happening.

The corrupted low memory printks contain the modifications. Can you
post them please ?

Thanks,

	tglx
