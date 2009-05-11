Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbZEKOCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbZEKOCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbZEKOBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:01:53 -0400
Received: from araneidae.co.uk ([62.3.233.233]:1516 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbZEKOBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:01:52 -0400
Date: Mon, 11 May 2009 15:01:49 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: =?GB2312?B?0sHU8w==?= <wxc200@gmail.com>
cc: Mark Brown <broonie@sirena.org.uk>, linux-i2c@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.29.2] PXA I2C: Define log level for i2c PXA error 
 report
In-Reply-To: <fd6b62c10905110629w6c9a641fr878351fb9217a32e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0905111458290.6308@venus.araneidae.co.uk>
References: <Pine.LNX.4.64.0905060829580.24668@venus.araneidae.co.uk> 
 <20090506102202.73d6045d@hyperion.delvare> <Pine.LNX.4.64.0905081102060.14384@venus.araneidae.co.uk>
  <fd6b62c10905110311w6350828tf90d9c699b73fe30@mail.gmail.com> 
 <Pine.LNX.4.64.0905111126020.20970@venus.araneidae.co.uk> 
 <20090511112801.GA20283@sirena.org.uk> <fd6b62c10905110629w6c9a641fr878351fb9217a32e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="682240-1874378263-1242050509=:6308"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--682240-1874378263-1242050509=:6308
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 11 May 2009, =D2=C1=D4=F3 wrote:
> 2009/5/11 Mark Brown <broonie@sirena.org.uk>:
> > On Mon, May 11, 2009 at 11:31:51AM +0100, Michael Abbott wrote:
> >
> >> static struct i2c_pxa_platform_data xcep_i2c_platform_data =A0=3D {
> >> =A0 =A0 =A0 =A0 .class =3D I2C_CLASS_HWMON
> >> };
> >
> >> ...
> >> =A0 =A0 =A0 =A0 pxa_set_i2c_info(&xcep_i2c_platform_data);
> >
> >> This is called in the .init_machine method, and the target system is a
> >> PXA255.
> >
> >> However, after the error messages on startup, all the sensors seem to =
be
> >> detected and seem to be operating normally.
> >
> > These errors occur when attempting to talk to non-existant devices=20
> > which is almost certainly going to happen with the class based device=
=20
> > probing since the kernel will probe for each device at each possible=20
> > address on each I2C bus.
> that happen when the device driver registered but the hardware doesnot=20
> exist.i once met this when my camera driver could not find the hardware=
=20
> camera.

Fair enough.  I have a bit of a challenge to specify the precise list of=20
I2C devices at the board level, as the board support is for a CPU module=20
with the I2C bus off-board ... and clearly I can live with the error=20
messages, anyway.

Still, I think it would make more sense for these to be one-liners; I=20
guess routine probing failures ought to be reported in a slightly=20
different way.  I'll see if I can figure out a sensible patch.
--682240-1874378263-1242050509=:6308--
