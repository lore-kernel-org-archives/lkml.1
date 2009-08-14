Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZHNRLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZHNRLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 13:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbZHNRLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 13:11:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:58475 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106AbZHNRLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 13:11:50 -0400
Date: Fri, 14 Aug 2009 10:09:13 -0700
From: Greg KH <gregkh@suse.de>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org, stable-review@kernel.org
Subject: Re: [patch 00/74] 2.6.30.5-stable review
Message-ID: <20090814170913.GA21596@suse.de>
References: <20090813195705.GA22393@kroah.com>
 <4A850395.4050204@pardus.org.tr>
 <20090814161523.GA11228@suse.de>
 <4A85984A.3050808@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A85984A.3050808@pardus.org.tr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 08:00:58PM +0300, Ozan Çağlayan wrote:
> Greg KH wrote:
> >> I wonder if it's possible to cherry-pick new device additions to
> >> usb-serial modem drivers (HSDPA stuff) for further releases?
> >>     
> >
> > Sure, send me the git commit ids that you want added please.
> >   
> 
> Sure, here they are:
> 
> 5549cb37decc151d9bc08dcdd8e8688bdfcd65b3: USB: FTDI-SIO new device ids
> 691aaeba045d7baebb0204b764b3097e01928d8c: USB: option.c: add Toshiba 3G
> HSDPA SM-Bus Minicard device id
> a29a5c747bbca21a0c44f11eb9ed61f0c3666907: USB: Ignore storage device in
> modem mode on DWN-652
> 9a2fa90fd2f059a2aa73c59f36e128725939d90e: USB: Identify Novatel MC760 in
> option driver
> 7150653c8875d073887bca5ed7b8ad3e8f3ef864: USB: option.c: add
> Qualcomm/Option iCON 210 modem
> 0390c0362629e93af40c1e974c28c0da27b4d0b3: USB: option.c to support Qisda
> H21/H20 usb modem
> f656f1df9fa262ae26ccbdf53051d6872c3998e1: USB: option: add Novatel
> Ovation MC760
> c224a634ddb92f8e73f4bf300db0b2f358c4e5fa: USB: option.c: add A-Link 3GU
> device id
> d7dcb148a03b9fffa0a1a9fdc1a681a90922ab10: USB serial: Add ID for
> Turtelizer, an FT2232L-based JTAG/RS-232 adapter.
> c4ed8ea74ae04159681beca6639117edad7e1092: USB: ftdi_sio: Add support for
> GN Otometrics Aurical USB Audiometer
> 746591ff6bf4a8214db531a42ec377737dc8a619: USB: option: add ZTE device
> ids and remove ONDA ids
> 407f4c156da4bd480c4b559558369f2dc5e9cc55: USB: option: Add USB ID for
> Novatel MC727/U727/USB727 refresh
> e7913e3dc09fb7720573c2d6d23b273c175e90cb: USB: serial: option: Add ZTE
> AC8710 usb modem device.
> 313726102937a53643e4c9db5b221f7f8346eee9: USB: option.c to support
> Alcatel X060S/X200 broadband modems

Ok, I'll consider these for the next -stable release.

But you do realize it is trivial to add new device ids to the driver
from userspace with no kernel changes needed, right?  So if you have a
specific device that you know works with newer kernels, you can just do
that until your distro updates to a newer kernel.

> And those are other ones that I'm seeing harmless but well it's all yours :)
> 
> 9e114d9cbebe66f4e85878f91011892399f72000: sis190: add new phy found on
> asus F5Sr laptop
> 66017b2c4ad3bb22349891aa9f77a91374cdce6b: mlx4_core: Add new ConnectX EN
> PCI ID 0x6764
> 03df33d7b903f3f835617a83eb12de24e7c077ed: New device ID for sc92031
> [1088:2031]
> e279d562faf7ba07e03481c843dd7e05fcb51f2c: Input: ALPS - Dell Latitude
> D630/D800 have DualPoint
> 831c28f00a586d3679549484acc47b3f33e902f4: Input: i8042 - more reset
> quirks for MSI Wind-clone netbooks
> 083d058e557f3d584526e8c2e2b60febed3ae9db: Input: atkbd - add forced
> release keys quirk for FSC Amilo Pi 3525
> de2688f419e6c80a4ab7f98a2eaeb48f9ac3ff7f: Input: i8042 - add Asus G1S to
> noloop exception list

I'll consider these as well.

thanks,

greg k-h
