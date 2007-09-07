Return-Path: <linux-kernel-owner+w=401wt.eu-S964980AbXIGFOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964980AbXIGFOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 01:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbXIGFOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 01:14:22 -0400
Received: from pat.uio.no ([129.240.10.15]:40344 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbXIGFOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 01:14:21 -0400
Subject: Re: NFS4 authentification / fsuid
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Satyam Sharma <satyam@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <5B1FC03A-6819-4C6C-91D3-F3022B798EF4@mac.com>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr>
	 <1188484155.6755.38.camel@heimdal.trondhjem.org>
	 <1188484337.6755.41.camel@heimdal.trondhjem.org>
	 <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr>
	 <1188486240.6755.51.camel@heimdal.trondhjem.org>
	 <20070830214431.GF10808@fieldses.org>
	 <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in>
	 <20070906150616.GA28565@fieldses.org>
	 <0D66E86D-8D97-45D7-9C2A-7AB5F42845B5@mac.com>
	 <1189121714.6672.38.camel@heimdal.trondhjem.org>
	 <5B1FC03A-6819-4C6C-91D3-F3022B798EF4@mac.com>
Content-Type: text/plain
Date: Fri, 07 Sep 2007 07:14:09 +0200
Message-Id: <1189142049.6681.29.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 9F529A8D15CA775F9929E63DCA776A1B44967BBA
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 73 total 3720356 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-06 at 20:56 -0400, Kyle Moffett wrote:
> On Sep 06, 2007, at 19:35:14, Trond Myklebust wrote:
> > On Thu, 2007-09-06 at 19:30 -0400, Kyle Moffett wrote:
> >> Actually, that's a fairly simple problem (barring disassembling  
> >> the system and attaching a hardware debugger).  You encrypt the  
> >> root filesystem and require a password to boot (See: LUKS).   
> >> Debian has built-in support for installing onto fs-on-LVM-on-crypt- 
> >> on-RAID, and it works quite well on all the laptops I use  
> >> regularly.  It's not even much of a speed penalty; once you take  
> >> the overhead of hitting a 5400RPM laptop drive you can chew  
> >> thousands of cycles of CPU without anybody noticing (much).  Then  
> >> all you have to do is burn a copy of your /boot with bootloader  
> >> onto some read-only media (like a finalized CDROM/DVDROM) and  
> >> you're set to go.
> >
> > Disconnect battery, and watch boot password go 'poof!'.
> 
> Umm, I did say "encrypt the root filesystem", didn't I?  Booting my  
> laptops this way follows this procedure:
>    1) Enter BIOS boot menu
>    2) Insert /boot CDROM
>    3) Select the "CDROM" entry
>    4) Wait for kernel to start and run through initramfs
>    5) Type password into the initramfs prompt so that it can DECRYPT  
> THE ROOT FILESYSTEM
>    6) Continue to boot the system.
> 
> Under this setup, tinkering with my BIOS does virtually nothing; the  
> only avenues of attack are strictly of the "Install a hardware  
> keylogger" variety.  Without my "boot" password you are looking at a  
> block device which appears to be little more than a random bit- 
> bucket, using AES-256 encryption.  If you can break that by  
> disconnecting the BIOS battery a lot of governments would be very  
> interested in the exact procedure. :-D  Furthermore if I think that  
> the hardware has been compromised I can pull out the HDD and my CDROM  
> and take them to a trusted computer to gain access to my data.
> 
> That said, a useful BIOS password helps keep somebody from casually  
> setting a supervisor password or mucking with the critical-to-boot  
> settings and making _me_ unplug the battery.
> 
> Cheers,
> Kyle Moffett

So an attacker will instead install a hardware keylogger, or swap out
your boot cdrom with a compromised but almost identical boot cdrom
instead, or mod your bios, ...

A fully self-certifying system that can prevent any attack is _very_
hard to achieve. Just ask apple (iPhone) or any games console vendor...

Trond

