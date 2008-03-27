Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbYC0Ndd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbYC0Ndd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760579AbYC0Nbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:31:33 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:52009 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760521AbYC0Nbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:31:32 -0400
Date: Thu, 27 Mar 2008 14:31:06 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: "Jan Dittmer" <jdi@l4x.org>
Cc: "Adrian Bunk" <bunk@kernel.org>, "Stephen Rothwell" <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 27
Message-ID: <20080327143106.4d05d3a6@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <621d098f0803270554j287ce58eme4b0e52cb6470154@mail.gmail.com>
References: <20080327183357.7c637aed.sfr@canb.auug.org.au>
	<20080327104224.2b98b561@hskinnemo-gx620.norway.atmel.com>
	<20080327104745.GA1686@cs181133002.pp.htv.fi>
	<20080327123226.452f0a3f@hskinnemo-gx620.norway.atmel.com>
	<20080327115459.GB1686@cs181133002.pp.htv.fi>
	<621d098f0803270554j287ce58eme4b0e52cb6470154@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2008 13:31:06.0469 (UTC) FILETIME=[CF771950:01C8900E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 13:54:23 +0100
"Jan Dittmer" <jdi@l4x.org> wrote:

> On Thu, Mar 27, 2008 at 12:54 PM, Adrian Bunk <bunk@kernel.org> wrote:
> > On Thu, Mar 27, 2008 at 12:32:26PM +0100, Haavard Skinnemoen wrote:
> >  > On Thu, 27 Mar 2008 12:47:45 +0200
> >  > Adrian Bunk <bunk@kernel.org> wrote:
> >  >
> >  > > According to Jan's page, there's still a build error with the defconfig:
> >  > >   http://l4x.org/k/?d=40450#err
> >  >
> >  > Hmm...that must be a pretty ancient toolchain.
> 
> That's the toolchain from back when avr32 was first integrated in the
> kernel. So it may be outdated, but I didn't read any statement on
> the contrary. I tend to keep the toolchains stable as long as
> possible.

Right...and like I said later in this thread, we should really try to
keep those toolchains working for as long as possible. So don't worry
about it.

> >  > FWIW, a more recent toolchain is available here:
> >  >
> >  > http://avr32linux.org/twiki/bin/view/Main/BinutilsPatches
> >  > http://avr32linux.org/twiki/bin/view/Main/GccPatches
> 
> So how can I get notified if I need a more recent toolchain?
> IMHO every architecture should have a file somewhere (in
> the kernel tree) where the required toolchain versions are
> listed and required patches are linked. That would make it
> such discussions unnecessary.

Good question. The problem is that there's really no way to tell until
someone actually runs into a problem, and when that happens, we might
as well try to fix it in the kernel.

There's no avr32 toolchain list (maybe we should add one), but the
buildroot@avr32linux.org list is probably a good bet if you want to
keep an eye on things.

Oh, and thanks a lot for doing these tests!

Haavard
