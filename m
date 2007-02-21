Return-Path: <linux-kernel-owner+w=401wt.eu-S1161314AbXBUP4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161314AbXBUP4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161313AbXBUP4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:56:38 -0500
Received: from violet.upc.es ([147.83.2.51]:49206 "EHLO violet.upc.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161310AbXBUP4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:56:36 -0500
From: Leopold Palomo-Avellaneda <lepalom@wol.es>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: Sata_via problems in a Vintage2-AE1: Resume
Date: Wed, 21 Feb 2007 16:56:18 +0100
User-Agent: KMail/1.9.5
Cc: Jean Delvare <jdelvare@suse.de>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jgarzik@pobox.com>
References: <200702090010.06897.lepalom@wol.es> <200702151223.19333.lepalom@wol.es> <45DC3018.7010704@gmail.com>
In-Reply-To: <45DC3018.7010704@gmail.com>
MIME-Version: 1.0
Message-Id: <200702211656.20120.lepalom@wol.es>
X-MIMETrack: Itemize by SMTP Server on Ackerman/UPC(Release 5.0.12  |February 13, 2003) at
 21/02/2007 16:56:22,
	Serialize by Router on Ackerman/UPC(Release 5.0.12  |February 13, 2003) at
 21/02/2007 16:56:24,
	Serialize complete at 21/02/2007 16:56:24
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
X-Mail-Scanned: Criba 2.0 + Clamd
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0.2 (violet.upc.es [147.83.2.51]); Wed, 21 Feb 2007 16:56:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A Dimecres 21 Febrer 2007 12:42, Tejun Heo va escriure:
> Leopold Palomo-Avellaneda wrote:
> > A Dimarts 13 Febrer 2007 17:19, Jean Delvare va escriure:
> >> Le Mardi 13 Février 2007 17:11, Leopold Palomo-Avellaneda a écrit :
> >>> A Dimarts 13 Febrer 2007 12:20, Jean Delvare va escriure:
> >>> (...)
> >>>
> >>>>>> *If* the VT8251 needs the VIA IRQ quirk, then the attached patch
> >>>>>> may help. Leopold, can you give it a try?
> >>>>>
> >>>>> Well, making your patch to the vanilla 2.6.20 the result is the same.
> >>>>> The box doesn't boot. Always the same problem ....
> >>>>
> >>>> If it's not a VIA IRQ problem, then there's nothing more I can do,
> >>>> sorry. Someone else will have to look into the problem.
> >>>>
> >>>> Out of curiosity, with my patch applied, did you see any "VIA VLink
> >>>> IRQ fixup" messages on the console?
> >>>
> >>> No :-(
> >>
> >> OK, so maybe the VT8251 actually no longer needs the quirk. Thanks for
> >> testing and reporting.
> >
> > Hi people,
> >
> > arriving to this state. What do you recommend?
> >
> > I have the box more or less working with irqpoll but with a lot of
> > messages: APIC error on CPU0: 08(08)
> >
> > and the box doesn't boot without the irqpoll option. Do you think that
> > the 2.6.21 have some kind of changes in this area?
> >
> > Thank's for all for you patience and your messages.
>
> I'm sorry but I'm clueless other than that it seems to be an irq routing
> problem.
>
> Any ideas, people?

Now, I have tested the 2.6.21-rc1 with the same result. Not boot....
I have one doubt, and maybe Mr Garzik could answer it. The changes in the 
ahci.c and sata_via.c for the 2.6.16 that I commented in a previous mails are 
incorporated in the next versions? 
Because all of us has presumed that yes, are equal and maybe not .....

Regards,

Thank's for all your patience ....

Leo
