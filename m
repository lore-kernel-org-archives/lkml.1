Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbXIONib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbXIONib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 09:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXIONiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 09:38:14 -0400
Received: from tag.witbe.net ([81.88.96.48]:55128 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbXIONiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 09:38:12 -0400
X-Greylist: delayed 1272 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Sep 2007 09:38:12 EDT
Date: Sat, 15 Sep 2007 15:38:08 +0200
From: Paul Rolland (=?UTF-8?Q?=E3=83=9D=E3=83=BC=E3=83=AB=E3=83=BB?=
	=?UTF-8?Q?=E3=83=AD=E3=83=A9=E3=83=B3?=) <rol@witbe.net>
To: Paul Rolland <rol@as2917.net>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>, rol@witbe.net
Subject: Re: [2.6.22.5] irq X: nobody cared but X is successfully used by
 libata
Message-ID: <20070915153808.424d0fbe@tux.DEF.witbe.net>
In-Reply-To: <20070909085923.76cebcb1@tux.DEF.witbe.net>
References: <20070826203513.4fa35f68@tux.DEF.witbe.net>
	<46E24DE8.4050603@gmail.com>
	<20070909085923.76cebcb1@tux.DEF.witbe.net>
Organization: Witbe.net
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Just to let you know that this seems to be over in 2.6.23-rc6.
Don't know exactly what fixed it, but it is no more present in my bootlog,
with or without the irqpoll option.

Nice job,
Regards,
Paul

On Sun, 9 Sep 2007 08:59:23 +0200
Paul Rolland <rol@as2917.net> wrote:

> Hello Tejun,
> 
> On Sat, 08 Sep 2007 16:23:20 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
> > Paul Rolland wrote:
> > > Hello,
> > > 
> > > My machine (an ASUS P5W-DH-Deluxe, Core2, 4Go RAM, 3 SATA and 2IDE) is
> > > reporting a :
> > > irq 23: nobody cared (try booting with the "irqpoll" option)
> > > together with a Call Trace, but :
> > >  - irqpoll is present on the command line,
> > >  - the irq is reported to be used by libata,
> > >  - the irqpoll option is mandatory if I want _some_ of my SATA disks to
> > > be accessible.
> > 
> > So, if you don't add the 'irqpoll' option, IO to disks don't work at all
> > after nobody cared message, right?
> 
> IO to disks don't work for SOME disks, but some others are still Ok (I've
> three SATA and two IDE).
> 
> Also, what is weird is the content of dmesg : after the nobody care, it
> looks as if IRQ 23 is reuse for another device (SMBus),
> but /proc/interrupts still reports it being used by libata.
> 
> I've been trying 2.6.23-rc5, and I'm still having this IRQ 23 nobody cared 
> message.
> 
> Regards,
> Paul
> 
> 
> 


-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
Witbe.net SA                                Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un navigateur 
"Some people dream of success... while others wake up and work hard at it" 

So much
depends
upon
a red

wheel
barrow
glazed with

rain
water
beside
the white
chickens.
		-- William Carlos Williams, "The Red Wheel Barrow"
