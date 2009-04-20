Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZDTOgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZDTOgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 10:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbZDTOgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 10:36:12 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:25635
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755833AbZDTOgL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 10:36:11 -0400
X-BigFish: VPS-42(zz542N1432R98dR936eQ1805M936fK9371Pzz1202hzz5a6ciz2dh6bh95p61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [microblaze-uclinux] [PATCH 11/11] microblaze: Kconfig: Enable drivers for Microblaze
Date: Mon, 20 Apr 2009 08:36:05 -0600
In-Reply-To: <977C41F842E66D4CB2E41332313B6150069D3D27@XSJ-EXCHVS1.xlnx.xilinx.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [microblaze-uclinux] [PATCH 11/11] microblaze: Kconfig: Enable drivers for Microblaze
Thread-Index: AcnBQyUpG3u8KbugTiy8ipV1dUsi2QAOD6N+ABJkAGA=
References: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu><74c0088dfda1816c21914c0a8da0c42908526c5e.1239874968.git.monstr@monstr.eu><20090417170707.B6C95C4004F@mail150-wa4.bigfish.com><fa686aa40904172249m5e261492w48c8d9d8446600e0@mail.gmail.com><495563870904181941o5a66126dgb59d8cad2b7a66f2@mail.gmail.com> <1d3f23370904191603s37a6a34clccc397707394650b@mail.gmail.com> <977C41F842E66D4CB2E41332313B6150069D3D27@XSJ-EXCHVS1.xlnx.xilinx.com>
From: John Linn <John.Linn@xilinx.com>
To: "Stephen Neuendorffer" <stephenn@xilinx.com>,
       "John Williams" <john.williams@petalogix.com>,
       <microblaze-uclinux@itee.uq.edu.au>
CC: <grant.likely@secretlab.ca>, "linuxppc-dev" <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Apr 2009 14:36:05.0696 (UTC) FILETIME=[5646AC00:01C9C1C5]
Message-ID: <20090420143606.4309C74804E@mail192-wa4.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Neuendorffer
> Sent: Sunday, April 19, 2009 11:52 PM
> To: John Williams; microblaze-uclinux@itee.uq.edu.au
> Cc: grant.likely@secretlab.ca; linuxppc-dev; linux-kernel@vger.kernel.org; John Linn
> Subject: RE: [microblaze-uclinux] [PATCH 11/11] microblaze: Kconfig: Enable drivers for Microblaze
> 
> 
> My thinking is that these drivers are likely to be used as a group,
> hence it would be nice to make it easy to get them all visible/enabled somehow.
> 
> Steve


It seems like John's suggestion of no arch filters would satisfy that also. Since FPGAs are used in so many different applications this would seem to open the drivers up to everyone regardless of what processor they're using. It's certainly less complex so I like it in that way.

But maybe I'm missing something here and there's a downside?

-- John

> 
> -----Original Message-----
> From: John Williams [mailto:john.williams@petalogix.com]
> Sent: Sun 4/19/2009 4:03 PM
> To: microblaze-uclinux@itee.uq.edu.au
> Cc: grant.likely@secretlab.ca; Stephen Neuendorffer; linuxppc-dev; linux-kernel@vger.kernel.org; John
> Linn
> Subject: Re: [microblaze-uclinux] [PATCH 11/11] microblaze: Kconfig: Enable drivers for Microblaze
> 
> On Sun, Apr 19, 2009 at 12:41 PM, Stephen Neuendorffer
> <stephen.neuendorffer@gmail.com> wrote:
> >
> >
> > On Fri, Apr 17, 2009 at 10:49 PM, Grant Likely <grant.likely@secretlab.ca>
> > wrote:
> >>
> >> On Fri, Apr 17, 2009 at 11:06 AM, Stephen Neuendorffer
> >> <stephen.neuendorffer@xilinx.com> wrote:
> >> >
> >> > Can we have XILINX_DRIVERS, please?  That way this can also be enabled
> >> > on any architecture that has FPGA peripherals.
> >>
> >> I've thought about this more, and I'd really rather not.  The list of
> >> affected drivers is short and is not a large maintenance burden.  I
> >> don't think a list of 2 or 3 architecture selects for each driver is
> >> unreasonable.  A "XILINX_DRIVERS" config item doesn't really help much
> >> anyway.  At any given time one of these drivers may be needed on
> >> another platform.  ie. the SystemACE device is present on at least one
> >> non-virtex, non-spartan platform.
> >
> > Which is exactly why having it architecture dependent isn't right...  All of
> > these drivers
> > could be needed and used on any OF-based platform.  If you have a platform
> > (for instance, a processor connected to an FPGA which has these peripherals
> > in the FPGA) then you should be able to enable these drivers.  Just my 2
> > cents...
> 
> What about the radical approach of having NO architecture
> filters/selectors?  Even if some random i386 user selects one of these
> drivers, so what?  It will still compile cleanly (if it doesn't we
> have to fix it), but there'll be no platform_device_register() call in
> their machine startup to actually cause driver / device binding.
> 
> No harm, no foul.  Problem goes away.
> 
> Then, as Grant points out, the rare cases where non-Xilinx platforms
> do use this stuff, they'll presumably know what they're doing and it's
> their responsibility to register the appropriate platform_device
> structures and make the magic happen.
> 
> John
> --
> John Williams, PhD, B.Eng, B.IT
> PetaLogix - Linux Solutions for a Reconfigurable World
> w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
> 


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


