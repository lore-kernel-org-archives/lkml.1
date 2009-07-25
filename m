Return-Path: <linux-kernel-owner+w=401wt.eu-S1752972AbZGYVG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbZGYVG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 17:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZGYVG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 17:06:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55464 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbZGYVG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 17:06:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH V2] au1xmmc: dev_pm_ops conversion
Date: Sat, 25 Jul 2009 23:06:56 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Manuel Lauss <manuel.lauss@googlemail.com>,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Manuel Lauss <manuel.lauss@gmail.com>,
       Arnaud Faucher <arnaud.faucher@gmail.com>, Erik Ekman <erik@kryo.se>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Paul Mundt <lethal@linux-sh.org>
References: <1248275919-3296-1-git-send-email-manuel.lauss@gmail.com> <200907252221.45407.elendil@planet.nl> <200907252238.05296.elendil@planet.nl>
In-Reply-To: <200907252238.05296.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907252306.57430.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 July 2009, Frans Pop wrote:
> On Saturday 25 July 2009, you wrote:
> > > I'll fix up the floppy and hp-wmi patches.
> >
> > Note that those are already in mainline, as is pcspkr.
> 
> Here's an overview of commits (that I could find) already in mainline that 
> look to have gotten it wrong:
> 
> 6daa79b3  drivers/serial/sh-sci.c	(Paul Mundt)
> 2dbc8a23  drivers/video/hitfb.c		(Paul Mundt)
> 35db715b  drivers/input/misc/pcspkr.c	(/me)
> 2702403c  drivers/platform/x86/hp-wmi.c	(/me)
> 142a735b  drivers/block/floppy.c	(/me)

Are you sure they're all in mainline?

The last change in mainline floppy.c happened on Jun 30 and I have the last
two (fixed up already) in my linux-next branch.

Best,
Rafael
