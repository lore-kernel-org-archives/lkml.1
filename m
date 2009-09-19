Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbZISOtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbZISOtL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 10:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbZISOtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 10:49:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57880 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753231AbZISOtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 10:49:09 -0400
X-Sasl-enc: IU+H2sdVto50QWYyJ4+OSFxwzgUQ3Vd9u5X4iVAlxTc9 1253371753
Date: Sat, 19 Sep 2009 11:49:11 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: Norbert Preining <preining@logic.at>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mattia Dongili <malattia@linux.it>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Matthias Welwarsky <matze@welwarsky.de>
Subject: Re: Linux not shutting down all devices? Battery drain in after
 shutdown
Message-ID: <20090919144911.GD28777@khazad-dum.debian.net>
References: <20090917122451.GA13717@gandalf.dynalias.org>
 <20090919103709.GA4466@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919103709.GA4466@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Sep 2009, Pavel Machek wrote:
> On Thu 2009-09-17 14:24:51, Norbert Preining wrote:
> > I have a very strange problem with my Sony VAIO Z11 laptop. When I turn
> > it off in Linux it still drains battery, and quite a lot indeed, several
> > percent per hour.
> > 
> > Interestingly, when shutting down from Windows XP the same doesn't happen,
> > after 10 hours of off time starting from 100% charge after rebooting I have
> > still 98.8%, so that is fine (counting that booting costs some energy).
> > 
> > This is in fact also a problem for many other users using Windows, too,
> > see [1]. I have checked that on Windows all devices are set up so that
> > at shutdown and hibernation (S4 and S5) they are going to off state (D3).
> > 
> > The only thing I can imagine is that one of the devices not completely
> > of not at all supported by the kernel is not properly shut down.
> > AFAIS the only device which I have not running here is the fingerprint
> > scanner.
> > 
> > My questions are:
> > - is there a way and if how to check that all devices will get properly
> >   shut down on halt?
> > - is there any other reason the battery drain might happen?
> > 
> > Some details about the laptop:
> > - it has a dual graphic card (Intel and nVidia), the sony-laptop module
> >   (extended for the zseries, see [2], with adaption to 2.6.31 by me [3]), 
> >   or the stock kernel sony-laptop plus the nvidia-control module 
> >   (by Matthew Garret [4]) can be used to turn the nvidia card of on a
> >   running system so that it does not draw any energy
> > - lspci -vvv output is attached as lspci.txt
> > - software running is Debian/sid with kernel 2.6.31
> 
> On PC, keyboard driver is expected to shut down the machine; I'd try
> complaining to Sony, perhaps they have newer bios.

I have seen this sort of problem on ThinkPads as well.  Lenovo decided to
fix it in firmware and shut down the stuff entirely in firmware.
Interestingly enough, in the ThinkPad case, Windows was not affected.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
