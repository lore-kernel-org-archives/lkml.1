Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbXIIG7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbXIIG7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 02:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbXIIG72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 02:59:28 -0400
Received: from tag.witbe.net ([81.88.96.48]:46654 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbXIIG72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 02:59:28 -0400
Date: Sun, 9 Sep 2007 08:59:23 +0200
From: Paul Rolland <rol@as2917.net>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [2.6.22.5] irq X: nobody cared but X is successfully used by
 libata
Message-ID: <20070909085923.76cebcb1@tux.DEF.witbe.net>
In-Reply-To: <46E24DE8.4050603@gmail.com>
References: <20070826203513.4fa35f68@tux.DEF.witbe.net>
	<46E24DE8.4050603@gmail.com>
Organization: AS2917.net
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

On Sat, 08 Sep 2007 16:23:20 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Paul Rolland wrote:
> > Hello,
> > 
> > My machine (an ASUS P5W-DH-Deluxe, Core2, 4Go RAM, 3 SATA and 2IDE) is
> > reporting a :
> > irq 23: nobody cared (try booting with the "irqpoll" option)
> > together with a Call Trace, but :
> >  - irqpoll is present on the command line,
> >  - the irq is reported to be used by libata,
> >  - the irqpoll option is mandatory if I want _some_ of my SATA disks to
> > be accessible.
> 
> So, if you don't add the 'irqpoll' option, IO to disks don't work at all
> after nobody cared message, right?

IO to disks don't work for SOME disks, but some others are still Ok (I've
three SATA and two IDE).

Also, what is weird is the content of dmesg : after the nobody care, it looks
as if IRQ 23 is reuse for another device (SMBus), but /proc/interrupts still
reports it being used by libata.

I've been trying 2.6.23-rc5, and I'm still having this IRQ 23 nobody cared 
message.

Regards,
Paul



-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
Witbe.net SA                                Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un navigateur 
"Some people dream of success... while others wake up and work hard at it" 

"I worry about my child and the Internet all the time, even though she's too 
young to have logged on yet. Here's what I worry about. I worry that 10 or 15 
years from now, she will come to me and say 'Daddy, where were you when they 
took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 
