Return-Path: <linux-kernel-owner+w=401wt.eu-S933072AbYCEXD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072AbYCEXD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763690AbYCEW6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:58:53 -0500
Received: from atlas.xpertsoft.com ([67.15.226.2]:39767 "EHLO atlas.dri.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106AbYCEW6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:58:52 -0500
Subject: [Fwd: Re: Dell OptiPlex 320 - Core 2 Duo]
From: Nuno Tavares <nuno.tavares@dri.pt>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Mar 2008 22:57:11 +0000
Message-Id: <1204757831.6067.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I now notice this hasn't been CC'ed to the list. Apologies to all.

-NT

------ Mensagem Reencaminhada ------
> Assunto: Re: Dell OptiPlex 320 - Core 2 Duo
> Data: Wed, 05 Mar 2008 22:49:18 +0000
> 
> Lennart, those options came from the SuSE installer, I guess. It wasn't
> me installing the machine, and I have no idea why the guy doing it
> whould add so many. I also found it strange, but since it's a Failsafe,
> and SuSE is not my favourite dist, I just left it alone. My first tests
> were done removing several of those (those that, to my knowledge, didn't
> make sense, like: acpi=off, apm=off, mce=off, maxcpus=0, probably
> pci=..).
> 
> Actually, the default boots to the not-failsafe:
> 
> kernel /boot/vmlinuz-2.6.22.5-23-default
> root=/dev/disk/by-id/scsi-SATA_WDC_WD800JD-75M_WD-WMAM9TA95509-part2
> apm=off acpi=off mce=off barrier=off ide=nodma idewait=50 i8042.nomux
> psmouse.proto=bare irqpoll pci=nommconf   resume=/dev/sda1 splash=silent
> showopts
> 
> Both share lots of options, anyway. I wonder what "irqpoll" does, though
> (it's probably related with "Misrouted IRQ fixup and polling support
> enabled" dmesg)... I just lack the opportunity to test all the
> combinations (the machine is remote)..
> 
> Even if the model is not the same as described, Optiplex has a nice
> (not!) history of problems:
> 
>  http://www.suseforums.net/index.php?showtopic=34172
> 
>  http://suseroot.com/blog/blog.php?postid=74
> 
> I forgot to mention that this last time I tried the combinations: 
> * acpi=on + pci=nomsi
> * acpi=on + pci=routeirq
> 
> -NT
> 
> 
> Qua, 2008-03-05 às 16:39 -0500, Lennart Sorensen escreveu:
> [...]
> > > kernel /boot/vmlinuz-2.6.22.5-23-default
> > > root=/dev/disk/by-id/scsi-SATA_WDC_WD800JD-75M_WD-WMAM9TA95509-part2
> > > showopts ide=nodma apm=off noresume noapic pci=route edd=off 3
> 
> [errata: it's pci=routeirq, obviously]
> 
> > > It didn't help. The boot stops at the line PCI: xxxxxx something. I'll
> > > try to try the BIOS update issue. I'll report back later.
> > 
> > Well most of the options seem like a bad idea in general.
> > 
> > ide=nodma, noapic and maxcpus I just can't imagine why would be listed
> > there.  Usually you add an option if it solves a problem, you don't add
> > all of the possible options.  Multi processor requires some of those
> > features, and disabling dma on ide makes no sense unless you are using a
> > very broken ide drive.
> > 
> > Who added all those options and why?
> > 
> > --
> > Len Sorensen
> > 
-- 
Nuno Tavares
DRI, Consultoria Informática
Telef: +351 936 184 086


