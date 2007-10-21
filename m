Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088AbXJUJMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbXJUJMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 05:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXJUJMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 05:12:09 -0400
Received: from tag.witbe.net ([81.88.96.48]:55341 "EHLO tag.witbe.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751309AbXJUJMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 05:12:07 -0400
Date: Sun, 21 Oct 2007 09:11:59 +0000
From: Paul Rolland <rol@as2917.net>
To: Tejun Heo <htejun@gmail.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [2.6.22.5] irq X: nobody cared but X is successfully used by
 libata
Message-ID: <20071021091159.08c75158@tux.DEF.witbe.net>
In-Reply-To: <47182323.10706@gmail.com>
References: <20070826203513.4fa35f68@tux.DEF.witbe.net>
	<6bffcb0e0708261637s3369dd6fl1f833461e41c4daa@mail.gmail.com>
	<47182323.10706@gmail.com>
Organization: AS2917.net
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, 19 Oct 2007 12:23:15 +0900
Tejun Heo <htejun@gmail.com> wrote:

> > On 26/08/07, Paul Rolland <rol@as2917.net> wrote:
> >> My machine (an ASUS P5W-DH-Deluxe, Core2, 4Go RAM, 3 SATA and 2IDE) is
> >> reporting a :
> >> irq 23: nobody cared (try booting with the "irqpoll" option)
> >> together with a Call Trace, but :
> >>  - irqpoll is present on the command line,
> >>  - the irq is reported to be used by libata,
> >>  - the irqpoll option is mandatory if I want _some_ of my SATA disks to
> >> be accessible.
> >>
> >> I've attached a file with :
> >>  - dmesg,
> >>  - cat /proc/interrupts
> >>  - lspci
> >>  - lspci -vvv
> >>  - my .config
> >>
> >> I've tried mounting and accessing all the disks, and it works.
> >> The last weird thing : though reported as used by libata, the irq 23
> >> counter seems to be fixed at 200001, though I've mounted and accessed
> >> all the disks !
> 
> Does this still happen with 2.6.23?  If so, please post boot log.  Thanks.
> 

Built and booted already twice, and so far, no problem anymore.
I'll continue to watch this carefully, and will report any problem that could
be related to this.

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
