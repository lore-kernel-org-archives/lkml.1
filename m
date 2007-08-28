Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbXH1Ll5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbXH1Ll5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 07:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbXH1Lls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 07:41:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:51734 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbXH1Llr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 07:41:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bcq8gkG7W9O5CdZ2NrxhAqykTOjQ2mM3je4SHLiz+4njkC5YI0KHtBFqw0Dm+jTeVlo5mBo047jUN8lbTZ8FN23pIA0IH5eSdyNGEDTH5TAYPbdytFJzOE5W3d9G6ob+RhjOuvrdQsgSFJ1eBWvtxDsPa+sEP8ZSUm6cE53gFmc=
Message-ID: <46D409FC.1070305@gmail.com>
Date: Tue, 28 Aug 2007 13:41:48 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       gareth@valinux.com, dri-devel@lists.sourceforge.net
Subject: Re: X freezes kernel during exit [Re: 2.6.23-rc3-mm1]
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46D17A7A.70609@gmail.com>
In-Reply-To: <46D17A7A.70609@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Does this went through to your boxes? Any progress, clue, idea?

Jiri Slaby napsal(a):
> Andrew Morton napsal(a):
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> 
> Hi,
> 
> I've found a regression against 2.6.23-rc2-mm2. X server shutdown freezes
> (untainted) kernel hardly. Nothing on netconsole, X output follows:
> 
> 
> X Window System Version 1.3.0
> Release Date: 19 April 2007
> X Protocol Version 11, Revision 0, Release 1.3
> Build Operating System: Fedora Core 7 Red Hat, Inc.
> Current Operating System: Linux bellona 2.6.23-rc3-mm1 #315 SMP Wed Aug 22
> 21:43:06 CEST 2007 i686
> Build Date: 11 June 2007
> Build ID: xorg-x11-server 1.3.0.0-9.fc7
>         Before reporting problems, check http://wiki.x.org
>         to make sure that you have the latest version.
> Module Loader present
> Markers: (--) probed, (**) from config file, (==) default setting,
>         (++) from command line, (!!) notice, (II) informational,
>         (WW) warning, (EE) error, (NI) not implemented, (??) unknown.
> (==) Log file: "/var/log/Xorg.0.log", Time: Sun Aug 26 14:22:43 2007
> (==) Using config file: "/etc/X11/xorg.conf"
> (WW) RADEON: No matching Device section for instance (BusID PCI:1:0:1) found
> (**) RADEON(0): RADEONPreInit
> (II) Module already built-in
> (II) Module already built-in
> (II) Module already built-in
> (**) RADEON(0): RADEONScreenInit f0000000 0
> (**) RADEON(0): Map: 0xf0000000, 0x04000000
> (**) RADEON(0): RADEONSave
> (**) RADEON(0): RADEONSaveMode(0x8240870)
> (**) RADEON(0): Read: 0x0000000c 0x00030065 0x00000000
> (**) RADEON(0): Read: rd=12, fd=101, pd=3
> (**) RADEON(0): RADEONSaveMode returns 0x8240870
> (**) RADEON(0): DRI New memory map param
> (**) RADEON(0): RADEONInitMemoryMap() :
> (**) RADEON(0):   mem_size         : 0x04000000
> (**) RADEON(0):   MC_FB_LOCATION   : 0xf3fff000
> (**) RADEON(0):   MC_AGP_LOCATION  : 0xffffffc0
> (**) RADEON(0): RADEONModeInit()
> 1280x1024     108.00  1280 1328 1440 1688  1024 1025 1028 1066 (24,32) +H +V
> 1280x1024     108.00  1280 1328 1440 1688  1024 1025 1028 1066 (24,32) +H +V
> (**) RADEON(0): Pitch = 10485920 bytes (virtualX = 1280, displayWidth = 1280)
> (**) RADEON(0): dc=10800, of=21600, fd=96, pd=2
> (**) RADEON(0): RADEONInit returns 0x8241220
> (**) RADEON(0): RADEONRestoreMode()
> (**) RADEON(0): RADEONRestoreMode(0x8241220)
> (**) RADEON(0): RADEONRestoreMemMapRegisters() :
> (**) RADEON(0):   MC_FB_LOCATION   : 0xf3fff000
> (**) RADEON(0):   MC_AGP_LOCATION  : 0xffffffc0
> (**) RADEON(0):   Map Changed ! Applying ...
> (**) RADEON(0):   Map applied, resetting engine ...
> (**) RADEON(0): Updating display base addresses...
> (**) RADEON(0): Memory map updated.
> (**) RADEON(0): Programming CRTC1, offset: 0x00000000
> (**) RADEON(0): Wrote: 0x0000000c 0x00010060 0x00000000 (0x0000a400)
> (**) RADEON(0): Wrote: rd=12, fd=96, pd=1
> (**) RADEON(0): GRPH_BUFFER_CNTL from 20205c5c to 20125c5c
> (**) RADEON(0): RADEONSaveScreen(0)
> (**) RADEON(0): Setting up initial surfaces
> (**) RADEON(0): Initializing fb layer
> (**) RADEON(0): Setting up accel memmap
> (**) RADEON(0): Initializing backing store
> (**) RADEON(0): DRI Finishing init !
> (**) RADEON(0): EngineRestore (32/32)
> (**) RADEON(0): GRPH_BUFFER_CNTL from 20205c5c to 20125c5c
> (**) RADEON(0): Setting up final surfaces
> (**) RADEON(0): Initializing Acceleration
> (**) RADEON(0): EngineInit (32/32)
> (**) RADEON(0): Pitch for acceleration = 160
> (**) RADEON(0): EngineRestore (32/32)
> (**) RADEON(0): Initializing DPMS
> (**) RADEON(0): Initializing Cursor
> (**) RADEON(0): Initializing color map
> (**) RADEON(0): Initializing DGA
> (**) RADEON(0): Initializing Xv
> (**) RADEON(0): RADEONScreenInit finished
> (**) RADEON(0): RADEONSaveScreen(2)
> (**) RADEON(0): RADEONCloseScreen
> (**) RADEON(0): RADEONDRIStop
> (**) RADEON(0): EngineRestore (32/32)
> (**) RADEON(0): RADEONDisplayPowerManagementSet(0,0x0)
> (**) RADEON(0): RADEONRestore
> (**) RADEON(0): RADEONRestoreMode()
> (**) RADEON(0): RADEONRestoreMode(0x8240870)
> (**) RADEON(0): RADEONRestoreMemMapRegisters() :
> (**) RADEON(0):   MC_FB_LOCATION   : 0x1fff0000
> (**) RADEON(0):   MC_AGP_LOCATION  : 0x27ff2000
> (**) RADEON(0):   Map Changed ! Applying ...
> (**) RADEON(0):   Map applied, resetting engine ...
> (**) RADEON(0): Updating display base addresses...
> (**) RADEON(0): Memory map updated.
> (**) RADEON(0): Programming CRTC1, offset: 0x00000000
> (**) RADEON(0): Wrote: 0x0000000c 0x00030065 0x00000000 (0x0000a400)
> (**) RADEON(0): Wrote: rd=12, fd=101, pd=3
> (**) RADEON(0): Disposing accel...
> (**) RADEON(0): Disposing cusor info
> (**) RADEON(0): Disposing DGA
> (**) RADEON(0): Unmapping memory
> (**) RADEON(0): RADEONDRICloseScreen
> 
> 
> 
> the only difference is, that 2.6.23-rc2-mm2 writes further
> 
> FreeFontPath: FPE "/usr/share/X11/fonts/misc:unscaled" refcount is 2, should be
> 1; fixing.
> 
> and exits succesfully (note that these messages are taken on remote host, X
> runned remotely).
> 
> Both vesa and radeon + Option "NoAccel" "true" works obviously fine.
> 
> regards,


-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
