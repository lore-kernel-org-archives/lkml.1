Return-Path: <linux-kernel-owner+w=401wt.eu-S1750805AbXBMQLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750805AbXBMQLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXBMQLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:11:33 -0500
Received: from dash.upc.es ([147.83.2.50]:47457 "EHLO dash.upc.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbXBMQLc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:11:32 -0500
From: Leopold Palomo-Avellaneda <lepalom@wol.es>
To: Jean Delvare <jdelvare@suse.de>
Subject: Re: Sata_via problems in a Vintage2-AE1
Date: Tue, 13 Feb 2007 17:11:10 +0100
User-Agent: KMail/1.9.5
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jgarzik@pobox.com>
References: <200702090010.06897.lepalom@wol.es> <200702121723.17999.lepalom@wol.es> <200702131220.21690.jdelvare@suse.de>
In-Reply-To: <200702131220.21690.jdelvare@suse.de>
MIME-Version: 1.0
Message-Id: <200702131711.11781.lepalom@wol.es>
X-MIMETrack: Itemize by SMTP Server on Ackerman/UPC(Release 5.0.12  |February 13, 2003) at
 13/02/2007 17:11:13,
	Serialize by Router on Ackerman/UPC(Release 5.0.12  |February 13, 2003) at
 13/02/2007 17:11:15,
	Serialize complete at 13/02/2007 17:11:15
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
  charset="iso-8859-13"
Content-Disposition: inline
X-Mail-Scanned: Criba 2.0 + Clamd
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0.2 (dash.upc.es [147.83.2.50]); Tue, 13 Feb 2007 17:11:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A Dimarts 13 Febrer 2007 12:20, Jean Delvare va escriure:
> Hi Leopold,
>
> Le Lundi 12 Février 2007 17:23, Leopold Palomo-Avellaneda a écrit :
> > A Dilluns 12 Febrer 2007 10:11, Jean Delvare va escriure:
> > > Did you report the problem to Asus? They should fix it. Maybe this new
> > > BIOS actually fixes some other problems you have.
> >
> > no. It's on the todo list. However I'm a bit afraid because I'm not using
> > the "official" system so probably they will say that "we do not support
> > ..."
>
> That's indeed probable, but if enough people report the same problems, they
> might still end up looking into it.
>
ok, I will try.

> > Well in http://via8251.la-evento.com/index.html
> >
> > <off topic>
> > please tell me that I'm not violating any rule about the linux-kernel
> > list putting this link :-S
> > </off topic>
> >
> > claims that the VT8251 are supported in 2.6.20. As always you nned to see
> > the official place .... :-(
>
> That's quite a bold claim considering that the VT8251 includes many
> different functions (PATA, SATA, USB, SMBus...) and can be configured
> differently on different motherboards. Maybe most functions are supposedly
> supported as of 2.6.20, but it doesn't mean everything works for everyone,
> as you are experiencing yourself.

sure, you're right.

> > > *If* the VT8251 needs the VIA IRQ quirk, then the attached patch may
> > > help. Leopold, can you give it a try?
> >
> > Well, making your patch to the vanilla 2.6.20 the result is the same. The
> > box doesn't boot. Always the same problem ....
>
> If it's not a VIA IRQ problem, then there's nothing more I can do, sorry.
> Someone else will have to look into the problem.
>
> Out of curiosity, with my patch applied, did you see any "VIA VLink IRQ
> fixup" messages on the console?

No :-(

Regards,

Leo
