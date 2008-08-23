Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYHWWit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYHWWit (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 18:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYHWWil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 18:38:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55173 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbYHWWik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 18:38:40 -0400
Message-ID: <48B0916C.4080805@garzik.org>
Date: Sat, 23 Aug 2008 18:38:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Sergey Spiridonov <sena@hurd.homeunix.org>
CC: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: GA-MA790FX-DS5 SATA ahci NCQ erros on Jmicron 20360/20363  (JMB363)
 kernel 2.6.25-2 Debian/Lenny
References: <g8p6po$nm$1@ger.gmane.org>
In-Reply-To: <g8p6po$nm$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Spiridonov wrote:
> Hi
> 
> I got kernel errors [1] and [2] followed by SATA reset on heavy load on
> the hard drive connected to the GA-MA790FX-DS5 onboard controller
> Jmicron 20360/20363 (JMB363) (here is lspci [3]). Hard drive connected
> to the another onboard (south bridge from AMD SB600) controller works
> without problem.
> 
> I got two 1TB Seagate hard disks, ST31000340AS and ST31000340NS. I
> connected one to Jmicron JMB363, another to SB600. After some testing
> with several instances of bonnie++ I got kernel errors [1] and [2].
> After this I exchanged hard disks connections. The one which was
> connected to JMB363 I connected to SB600 and vs versa. Errors, timeouts
> and hard drive resetting happened always on the hard drive which is
> connected to the JMB363 (in log file it is sdb). There are no errors if
> both drives are connected to the SB600.
> 
> Here [4] is complete (before i get errors) dmesg output after system is
> booted.
> 
> I already replaced (took from working PC) power supply, memory, video
> card and dvd drive. I get same problems also with this devices. So
> problem must be motherboard, software or CPU. CPU seems to work O.K.
> 
> It looks like the problem is motherboard or ahci ata driver. Does
> somebody have any clue about it? Is chip JMB363 broken or linux driver
> is broken?
> 
> [1] http://hurd.homeunix.org/~sena/GA-MA790FX-DS5/dmesg-sata-errors.txt
> [2] http://hurd.homeunix.org/~sena/GA-MA790FX-DS5/dmesg-sata-errors2.txt
> [3] http://hurd.homeunix.org/~sena/GA-MA790FX-DS5/lspci.txt
> [4] http://hurd.homeunix.org/~sena/GA-MA790FX-DS5/dmesg-after-boot.txt


See http://ata.wiki.kernel.org/index.php/Libata_error_messages for an 
introduction.

In general, tons of ATA bus errors and SError register bits means that 
problems are coming from the ATA bus, a.k.a. the SATA cable and its 
related connections.

So...  suspect bad cables, bad port connectors, cable interference, 
motherboard-caused interference or grounding problems, power supply 
problems.

	Jeff



