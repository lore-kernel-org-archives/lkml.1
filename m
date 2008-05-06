Return-Path: <linux-kernel-owner+w=401wt.eu-S1763755AbYEFARW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763755AbYEFARW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbYEFARK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:17:10 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:2218 "EHLO
	outbound1-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755817AbYEFARG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:17:06 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 10/56] microblaze_v2: Generic dts file for platforms
Date: Mon, 5 May 2008 17:17:09 -0700
In-reply-to: <1210032615.5798.174.camel@localhost>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 10/56] microblaze_v2: Generic dts file for platforms
Thread-Index: AcivDaz//3IleiY+TKiIvAX8bCeiOwAAHYHw
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu> <20080505172535.9710319B8086@mail101-wa4.bigfish.com> <1210029394.5798.140.camel@localhost> <20080505233234.59C381488046@mail76-wa4.bigfish.com> <1210032615.5798.174.camel@localhost>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: "John Williams" <john.williams@petalogix.com>
Cc: <monstr@seznam.cz>, <linux-kernel@vger.kernel.org>, <arnd@arndb.de>,
       <linux-arch@vger.kernel.org>, "John Linn" <linnj@xilinx.com>,
       <matthew@wil.cx>, <will.newton@gmail.com>, <drepper@redhat.com>,
       <microblaze-uclinux@itee.uq.edu.au>, <grant.likely@secretlab.ca>,
       "Michal Simek" <monstr@monstr.eu>
X-OriginalArrivalTime: 06 May 2008 00:17:05.0689 (UTC) FILETIME=[83DEF890:01C8AF0E]
Message-Id: <20080506001706.160C31310089@mail24-wa4.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   In fact, in most cases, I'd like to make the .dts file part of
> > the bitstream and not compiled into the kernel.
> 
> Well, I've just run out of BRAM on a V5LX50T design so please don't
ask
> for more of it to store a DTC! :)  Or do you mean to piggyback on the
> tail of the configuration stream and read with some kind of JTAG user
> code?

That's a possibility.  More likely, it can get stuffed in the low BRAM
and ripped out during boot time.  I've got the same trick working on
ppc, using the BRAM at the reset vector.  

> > Although powerpc has a bit more boot-time complexity than the
microblaze
> > does currently, I think it makes alot of sense to have some
consistency
> > here, and there is already a pattern to follow here which nicely
> > orthogonalizes multiple .dts files for the same platform code.
> 
> arch/powerpc/boot is building a bootloader, so maybe that's why .dts
> files belong there.  The bootloader is really the only thing that
cares
> about them as objects.  Once the kernel starts, it's just
dereferencing
> a pointer that happens to point to a datastructure it understands (or
> copying it as a blob before doing same).
> 
> In fact, you could mount an argument that .dts files don't belong
> anywhere near the MicroBlaze kernel, since our build process never
> actually touches them.

Well, that was part of my argument that they shouldn't be part of the
platform code, but I guess I wasn't clear enough... :)

Steve



