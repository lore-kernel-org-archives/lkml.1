Return-Path: <linux-kernel-owner+w=401wt.eu-S936475AbXLTSOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936475AbXLTSOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757320AbXLTSOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:14:06 -0500
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:60761 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046AbXLTSOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:14:05 -0500
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: linux-kernel@vger.kernel.org
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as well
User-Agent: KMail/1.9.7
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de> <200712200653.28996.volker.armin.hemmann@tu-clausthal.de> <1198134579.4429.10.camel@homer.simson.net>
In-Reply-To: <1198134579.4429.10.camel@homer.simson.net>
MIME-Version: 1.0
Content-Disposition: inline
Date: Thu, 20 Dec 2007 19:14:01 +0100
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200712201914.01103.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag, 20. Dezember 2007, you wrote:
> On Thu, 2007-12-20 at 06:53 +0100, Hemmann, Volker Armin wrote:
> > On Donnerstag, 20. Dezember 2007, you wrote:
> > > On Thu, 2007-12-20 at 03:13 +0100, Hemmann, Volker Armin wrote:
> > > > On Montag, 17. Dezember 2007, you wrote:
> > > >
> > > > and another one, this time tainted with the nvidia module:
> > > > 5194.130985] Unable to handle kernel paging request at
> > > > 0000030000000000 RIP:
> > >
> > > This really sounds like bad hardware. Either memory or the mobo/riser
> > > card the memory is on. You might try lowering the memory timings of
> > > your memory in BIOS. Try removing 1/2 of your memory. If it still
> > > remove the other 1/2 and put the first 1/2 back and try again.
> >
> > if this is bad hardware why:
> >
> > - didn't this show up earlier?
> >
> > - did a several hour memtest run couple of weeks ago didn't show up
> > anything?
> >
> > - and does stuff like compiling all of kde 3.5.8 or the latest kde4 rc
> > finish without any problems?
>
> Because bad hardware can be highly sensitive to exact load patterns.
> Don't be so skeptical of the suggestion that your hardware may be
> flakey, in the last 30+ years as a hardware guy in the design lab and in
> the field, I've seen very much hardware which passed extensive
> diagnostics, but turn out to be flakey nonetheless.
>
> I would suggest that you rearrange your ram modules, and see if the bit
> pattern changes.  Memtest may not show a problem with bitflips... if
> that's happening.  I would also suggest that you check your case
> temperature as someone else suggested - lmsensors may say that the CPU
> temperature is fine, but that isn't the whole picture. by a long shot.
>
> 	-Mike

case temp: 25°C measured near a warm harddisk by a digital thermometer.
mainboard temp: 31°C measured by lmsensors (mobo bios agrees)
cpu temp: 29-50°C (load dependent) measured by lmsensors, bios puts on two 
additional degrees.

I have 4 'big' fans installed to have a constant air stream in the case.

This really does not look like overheating. And I did have flaky ram in the 
past. The thing is, apart from the oops the system is completly, perfectly 
stable. That really does not smell like flaky hardware. At least not in my 
experience. Flaky PSU = sudden reboots, boot problems, crashes under load. 
Flaky mobo = see flaky psu. Flaky Ram: crashes, crashes, more crashes, 
segfaults here and there, especially when updating glibc, qt or kde. 

And I don't get this. I only get oopses.

It is just.. I could be the hardware - but I should have seen the 
same 'problem' with earlier kernels - and the 'almost daily oops' only 
started with 2.6.23.
