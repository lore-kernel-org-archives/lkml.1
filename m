Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbYFZUS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbYFZUS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 16:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYFZUSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 16:18:16 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:46322 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYFZUSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 16:18:15 -0400
X-BigFish: VPS-55(z1039oz542N1432R541L98dR4015M7efV18c1K1805M655Oc8k11e3izzzzd6eM15cbj5a6ciz2dh6bh61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 12/60] microblaze_v4: Generic dts file for platforms
Date: Thu, 26 Jun 2008 13:18:11 -0700
In-Reply-To: <4863E68C.30802@seznam.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 12/60] microblaze_v4: Generic dts file for platforms
Thread-Index: AcjXvmP5ypPjqYdfS7uJZoWgStAdRQAC0Klw
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>	<1214483429-32360-2-git-send-email-monstr@seznam.cz>	<1214483429-32360-3-git-send-email-monstr@seznam.cz>	<1214483429-32360-4-git-send-email-monstr@seznam.cz>	<1214483429-32360-5-git-send-email-monstr@seznam.cz>	<1214483429-32360-6-git-send-email-monstr@seznam.cz>	<1214483429-32360-7-git-send-email-monstr@seznam.cz>	<1214483429-32360-8-git-send-email-monstr@seznam.cz>	<1214483429-32360-9-git-send-email-monstr@seznam.cz>	<1214483429-32360-10-git-send-email-monstr@seznam.cz>	<1214483429-32360-11-git-send-email-monstr@seznam.cz>	<1214483429-32360-12-git-send-email-monstr@seznam.cz>	<1214483429-32360-13-git-send-email-monstr@seznam.cz><4863B096.7020309@freescale.com> <4863E68C.30802@seznam.cz>
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: <monstr@seznam.cz>, "Jon Loeliger" <jdl@freescale.com>
CC: <linux-arch@vger.kernel.org>, <alan@lxorguk.ukuu.org.uk>, <arnd@arndb.de>,
       <vapier.adi@gmail.com>, <matthew@wil.cx>,
       <microblaze-uclinux@itee.uq.edu.au>, <linux-kernel@vger.kernel.org>,
       <drepper@redhat.com>, <linuxppc-dev@ozlabs.org>,
       <will.newton@gmail.com>, <hpa@zytor.com>,
       "John Linn" <linnj@xilinx.com>, <john.williams@petalogix.com>
X-OriginalArrivalTime: 26 Jun 2008 20:18:12.0881 (UTC) FILETIME=[C2550810:01C8D7C9]
Message-ID: <20080626201813.9662411E0051@mail20-wa4.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's on my list of things to do, but I'm swamped with a few deadlines at
the moment.

Steve

> -----Original Message-----
> From: linuxppc-dev-bounces+stephen.neuendorffer=xilinx.com@ozlabs.org
[mailto:linuxppc-dev-
> bounces+stephen.neuendorffer=xilinx.com@ozlabs.org] On Behalf Of
Michal Simek
> Sent: Thursday, June 26, 2008 11:57 AM
> To: Jon Loeliger
> Cc: linux-arch@vger.kernel.org; alan@lxorguk.ukuu.org.uk;
arnd@arndb.de; vapier.adi@gmail.com;
> matthew@wil.cx; microblaze-uclinux@itee.uq.edu.au;
linux-kernel@vger.kernel.org; drepper@redhat.com;
> linuxppc-dev@ozlabs.org; will.newton@gmail.com; hpa@zytor.com; John
Linn; john.williams@petalogix.com
> Subject: Re: [PATCH 12/60] microblaze_v4: Generic dts file for
platforms
> 
> OK. We have to change fdt generator with Steve.
> 
> Steve: can you look at it?
> 
> M
> 
> 
> > monstr@seznam.cz wrote:
> >> From: Michal Simek <monstr@monstr.eu>
> >>
> >>
> >> Signed-off-by: Michal Simek <monstr@monstr.eu>
> >> ---
> >>  arch/microblaze/platform/generic/system.dts |  300
> >> +++++++++++++++++++++++++++
> >>  1 files changed, 300 insertions(+), 0 deletions(-)
> >>  create mode 100644 arch/microblaze/platform/generic/system.dts
> >>
> >> diff --git a/arch/microblaze/platform/generic/system.dts
> >> b/arch/microblaze/platform/generic/system.dts
> >> new file mode 100644
> >> index 0000000..724a037
> >> --- /dev/null
> >> +++ b/arch/microblaze/platform/generic/system.dts
> >> @@ -0,0 +1,300 @@
> >> +/*
> >> + * (C) Copyright 2007-2008 Xilinx, Inc.
> >> + * (C) Copyright 2007-2008 Michal Simek
> >> + *
> >> + * Michal SIMEK <monstr@monstr.eu>
> >> + *
> >> + * This program is free software; you can redistribute it and/or
> >> + * modify it under the terms of the GNU General Public License as
> >> + * published by the Free Software Foundation; either version 2 of
> >> + * the License, or (at your option) any later version.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> >> + * GNU General Public License for more details.
> >> + *
> >> + * You should have received a copy of the GNU General Public
License
> >> + * along with this program; if not, write to the Free Software
> >> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
> >> + * MA 02111-1307 USA
> >> + *
> >> + * CAUTION: This file is automatically generated by libgen.
> >> + * Version: Xilinx EDK 9.2.02 EDK_Jm_SP2.3
> >> + * Generate by FDT v1.00.a
> >> + */
> >> +
> >> +/ {
> >> +    #address-cells = <1>;
> >> +    #size-cells = <1>;
> >> +    compatible = "xlnx,microblaze";
> >> +    model = "testing";
> >> +    DDR_SDRAM_32Mx16: memory@20000000 {
> >> +        device_type = "memory";
> >> +        reg = < 20000000 2000000 >;
> >> +    } ;
> >> +    chosen {
> >> +        bootargs = "console=ttyUL0,115200 loglevel=15";
> >> +        linux,stdout-path = "/plb@0/serial@40100000";
> >> +    } ;
> >> +    cpus {
> >> +        #address-cells = <1>;
> >> +        #cpus = <1>;
> >> +        #size-cells = <0>;
> >> +        microblaze_0: cpu@0 {
> >> +            clock-frequency = <2faf080>;
> >
> >
> > This should really be using the /dts-v1/ format now.
> >
> > Thanks,
> > jdl
> >
> > _______________________________________________
> > Linuxppc-dev mailing list
> > Linuxppc-dev@ozlabs.org
> > https://ozlabs.org/mailman/listinfo/linuxppc-dev
> >
> >
> >
------------------------------------------------------------------------
> >
> >
> > No virus found in this incoming message.
> > Checked by AVG.
> > Version: 8.0.101 / Virus Database: 270.4.1/1519 - Release Date:
25.6.2008 04:13
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


