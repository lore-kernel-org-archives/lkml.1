Return-Path: <linux-kernel-owner+w=401wt.eu-S1760947AbZATMp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbZATMp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 07:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbZATMpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 07:45:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33641 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbZATMpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 07:45:08 -0500
Date: Tue, 20 Jan 2009 13:47:11 +0100
From: Pavel Machek <pavel@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com,
       trenn@suse.de, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, hmacht@novell.com
Subject: Re: 2.6.29-rc2: thinkpad dock -- cdrom vs. s2ram
Message-ID: <20090120124711.GA1920@elf.ucw.cz>
References: <20090119202423.GA7070@ucw.cz> <200901192150.59438.rjw@sisk.pl> <20090119221508.GA2576@elf.ucw.cz> <20090120000305.7895eff9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120000305.7895eff9@lxorguk.ukuu.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-01-20 00:03:05, Alan Cox wrote:
> > I guess I'm confused. I tried:
> 
> You want CONFIG_IDE = n, CONFIG_ATA_SFF = y, CONFIG_ATA_PIIX = y

Thanks.

With those options, cdrom moved from hda to sr0, and is correctly
unregistered when undocking. Unfortunately, it is not correctly
re-registered when I insert machine back into the dock :-(... so
something is still not right in docking area.

							Pavel

coda: Unexpected interruption.
Failure of coda_cnode_make for root: error -4
ata5.00: disabled
ata5.00: detaching (SCSI 4:0:0:0)
sr 4:0:0:0: rejecting I/O to dead device
sr 4:0:0:0: rejecting I/O to dead device
ACPI: \_SB_.GDCK - undocking
usb usb1: usb resume
ehci_hcd 0000:00:1d.7: resume root hub
hub 1-0:1.0: hub_resume
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001002 POWER sig=se0
CSC
hub 1-0:1.0: port 6: status 0100 change 0001
hub 1-0:1.0: state 7 ports 8 chg 0040 evt fe00
hub 1-0:1.0: port 6, status 0100, change 0000, 12 Mb/s
usb 1-6: USB disconnect, address 2
usb 1-6: unregistering device
usb 1-6: usb_disable_device nuking all URBs
usb 1-6: unregistering interface 1-6:1.0
usb 1-6:1.0: uevent
usb 1-6: uevent
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1d.7: suspend root hub
usb usb1: usb resume
ehci_hcd 0000:00:1d.7: resume root hub
hub 1-0:1.0: hub_resume
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001803 POWER sig=j CSC
CONNECT
hub 1-0:1.0: port 6: status 0501 change 0001
hub 1-0:1.0: state 7 ports 8 chg 0040 evt fe00
hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1d.7: port 6 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001005 POWER sig=se0 PE
CONNECT
usb 1-6: new high speed USB device using ehci_hcd and address 5
ehci_hcd 0000:00:1d.7: port 6 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001005 POWER sig=se0 PE
CONNECT
usb 1-6: New USB device found, idVendor=17ef, idProduct=1000
usb 1-6: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-6: uevent
usb 1-6: usb_probe_device
usb 1-6: configuration #1 chosen from 1 choice
usb 1-6: adding 1-6:1.0 (config #1, interface 0)
usb 1-6:1.0: uevent
hub 1-6:1.0: usb_probe_interface
hub 1-6:1.0: usb_probe_interface - got id
hub 1-6:1.0: USB hub found
hub 1-6:1.0: 4 ports detected
hub 1-6:1.0: standalone hub
hub 1-6:1.0: individual port power switching
hub 1-6:1.0: individual port over-current protection
hub 1-6:1.0: TT per port
hub 1-6:1.0: TT requires at most 8 FS bit times (666 ns)
hub 1-6:1.0: power on to power good time: 100ms
hub 1-6:1.0: local power source is good
hub 1-6:1.0: enabling power on all ports
/data/l/linux/drivers/usb/core/inode.c: creating file '005'
usb 1-6: link qh256-0001/f6238080 start 255 [1/0 us]
hub 1-6:1.0: state 7 ports 4 chg 0000 evt 0000
hub 1-6:1.0: hub_suspend
usb 1-6: unlink qh256-0001/f6238080 start 255 [1/0 us]
usb 1-6: usb auto-suspend
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1d.7: suspend root hub

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
