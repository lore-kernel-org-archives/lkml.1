Return-Path: <linux-kernel-owner+w=401wt.eu-S1762072AbYBMT2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762072AbYBMT2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYBMT2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:28:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52149 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937AbYBMT17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:27:59 -0500
Date: Wed, 13 Feb 2008 11:27:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mikem13@sbcglobal.net
Cc: linux-kernel@vger.kernel.org, Fabio Coatti <cova@ferrara.linux.it>
Subject: Re: stuck with 2.6.23.14 on x86_64
Message-Id: <20080213112713.e028075f.akpm@linux-foundation.org>
In-Reply-To: <04a37899-eb7b-43ae-a7ab-1928ca1a0e35@s12g2000prg.googlegroups.com>
References: <fa.d3EyknDimPJIlJNA2Y25+wmntNM@ifi.uio.no>
	<04a37899-eb7b-43ae-a7ab-1928ca1a0e35@s12g2000prg.googlegroups.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 08:05:58 -0800 (PST)
mikem13@sbcglobal.net wrote:

> On Feb 12, 8:13 am, Fabio Coatti <c...@ferrara.linux.it> wrote:
> > Hi all,
> > I'm stuck in a weird situation: I'm unable to go beyond 2.6.23.14, so to fix
> > the splice bug I've had to apply by hand the patch. (x86_64)
> >
> > Basically, with 2.6.24.2 (the same with 2.6.24 and .1), tha machine won't boot
> > due to a problem with cciss driver, that prevents to find the / partition.
> > (bug described here: Kernel Bug Tracker Bug 9859http://bugzilla.kernel.org/show_bug.cgi?id=9859);
> >
> > With kernels 2.6.23, the lastest that I can compile is 2.6.23.14; starting
> > from .15 (and .16) I get this message:
> >
> > ======================
> >   UPD     include/linux/compile.h
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `acpi_init':
> > bus.c:(.init.text+0x1713): undefined reference to `pm_flags'
> > bus.c:(.init.text+0x1756): undefined reference to `pm_flags'
> > ======================
> >
> > All .config are the same, (make oldconfig) beside the obvious differences
> > between .23 and .24
> >
> > Hardware: x86_64 AMD 2216HE
> > SCSI controller: HP Smart Array E200i Controller
> > Compiler: gcc (GCC) 4.1.1
> > binutils: 2.16.1
> >
> > On a x86 machine, Intel(R) Xeon(TM) CPU 3.20GHz
> > with a cciss0: HP Smart Array 6i Controller,
> > the 2.6.24.2 compiles just fine and works, so the cciss problems seems related
> > only to E200i controller.
> >
> > Right now, on AMD64 machines, I'm forced to patch by hand the kernel, that's
> > quite uncomfortable :)
> >
> > Can someone point me in the right direction to get out of this situation? Of
> > course I can provide any further information. (.config not inlcuded now to
> > avoid cluttering  )
> >
> > Thanks for any answer.
> >
> > --
> > Fabio "Cova" Coatti    http://members.ferrara.linux.it/cova
> > Ferrara Linux Users Group          http://ferrara.linux.it
> > GnuPG fp:9765 A5B6 6843 17BC A646  BE8C FA56 373A 5374 C703
> > Old SysOps never die... they simply forget their password.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majord...@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> Fabio, Can you please post your boot messages in bug 9859.

Let's cc him..
