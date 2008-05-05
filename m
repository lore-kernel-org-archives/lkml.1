Return-Path: <linux-kernel-owner+w=401wt.eu-S1763272AbYEEXRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763272AbYEEXRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761943AbYEEXR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:17:28 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:50274 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761804AbYEEXR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:17:26 -0400
X-ClientAddr: 220.233.82.121
Subject: RE: [PATCH 10/56] microblaze_v2: Generic dts file for platforms
From: John Williams <john.williams@petalogix.com>
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: monstr@seznam.cz, linux-kernel@vger.kernel.org, arnd@arndb.de,
       linux-arch@vger.kernel.org, John Linn <linnj@xilinx.com>,
       matthew@wil.cx, will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
In-Reply-To: <20080505172535.9710319B8086@mail101-wa4.bigfish.com>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
	 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
	 <20080505172535.9710319B8086@mail101-wa4.bigfish.com>
Content-Type: text/plain
Organization: PetaLogix
Date: Tue, 06 May 2008 09:16:34 +1000
Message-Id: <1210029394.5798.140.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: john.williams@petalogix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-05 at 10:25 -0700, Stephen Neuendorffer wrote:
> I think it would be nice if dts files were stored in boot/dts, as on
> powerpc, which would reduce confusion.

I'm not so sure.  By grouping 

 * the DTS
 * Kconfig.auto (now just storing CPU parameters for CPUFLAGS); and
 * board-specific setup.c if required, 

we concentrate in one place, in a single subdir of
arch/microblaze/platform/*, all of the board specific info.  

Maybe our Kbuild should copy the platform .dts file out of the platform
dir and into microblaze/boot, like we do with the finished kernel?  Then
it's ready to be picked up by the user or some higher level build tool.

If users or vendors want to maintain multiple DTS files for a single
board, again they can just collect them in the platform subdir so their
intended target remains obvious.

John


> 
> Steve
> 
> > -----Original Message-----
> > From: monstr@seznam.cz [mailto:monstr@seznam.cz]
> > Sent: Sunday, May 04, 2008 4:41 AM
> > To: linux-kernel@vger.kernel.org
> > Cc: arnd@arndb.de; linux-arch@vger.kernel.org; Stephen Neuendorffer;
> John Linn;
> > john.williams@petalogix.com; matthew@wil.cx; will.newton@gmail.com;
> drepper@redhat.com; microblaze-
> > uclinux@itee.uq.edu.au; grant.likely@secretlab.ca; Michal Simek
> > Subject: [PATCH 10/56] microblaze_v2: Generic dts file for platforms
> > 
> > From: Michal Simek <monstr@monstr.eu>
> > 
> > 
> > Signed-off-by: Michal Simek <monstr@monstr.eu>
> > ---
> >  arch/microblaze/platform/generic/system.dts |  137
> +++++++++++++++++++++++++++
> >  1 files changed, 137 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/microblaze/platform/generic/system.dts
> 
-- 
John Williams, PhD, B.Eng, B.IT
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663


