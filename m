Return-Path: <linux-kernel-owner+w=401wt.eu-S1761817AbYBMPkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761817AbYBMPkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758141AbYBMPkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:40:04 -0500
Received: from senator.holtmann.net ([87.106.208.187]:55275 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbYBMPkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:40:03 -0500
Subject: Re: [PATCH][BLUETOOTH] add HCI_BROKEN_ISOC for 0e5e:6622 (bugzilla
	#9027)
From: Marcel Holtmann <marcel@holtmann.org>
To: SDiZ <sdiz@sdiz.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47B30E11.2080903@sdiz.net>
References: <47B266AE.3040908@sdiz.net> <1202898692.7664.369.camel@violet>
	 <47B30E11.2080903@sdiz.net>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 16:40:06 +0100
Message-Id: <1202917206.7664.417.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >> This patch fix bugzilla #9027.
> >> ``Syslog flooded with "hci_scodata_packet: hci0 SCO packet for unknown
> >> connection handle 92" message"
> >>
> >> see http://bugzilla.kernel.org/show_bug.cgi?id=9027
> >>     
> >
> > when we get the content of /proc/bus/usb/devices for this one. Do you
> > have the manufacturer name of it or at least an idea which kind of
> > device this is. Check "hciconfig hci0 version".
> >   
> It have no text on the chips and package, so I don't know the
> manufacturer name.

and what about "hciconfig hci0 version"?

> /proc/bus/usb/devices shows:
> 
> 
> T: Bus=01 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 2 Spd=12 MxCh= 0
> D: Ver= 1.10 Cls=e0(unk. ) Sub=01 Prot=01 MxPS=16 #Cfgs= 1
> P: Vendor=0e5e ProdID=6622 Rev= 1.34
> C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=100mA
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
> E: Ad=81(I) Atr=03(Int.) MxPS= 16 Ivl=1ms
> E: Ad=82(I) Atr=02(Bulk) MxPS= 64 Ivl=0ms
> E: Ad=02(O) Atr=02(Bulk) MxPS= 64 Ivl=0ms
> I: If#= 1 Alt= 0 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
> E: Ad=83(I) Atr=01(Isoc) MxPS= 0 Ivl=1ms
> E: Ad=03(O) Atr=01(Isoc) MxPS= 0 Ivl=1ms
> I: If#= 1 Alt= 1 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
> E: Ad=83(I) Atr=01(Isoc) MxPS= 9 Ivl=1ms
> E: Ad=03(O) Atr=01(Isoc) MxPS= 9 Ivl=1ms
> I:* If#= 1 Alt= 2 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
> E: Ad=83(I) Atr=01(Isoc) MxPS= 17 Ivl=1ms
> E: Ad=03(O) Atr=01(Isoc) MxPS= 17 Ivl=1ms

That is not all. Otherwise it is violating the Bluetooth HCI USB
specification and we have bigger problems when switching USB alternate
endpoints.

Regards

Marcel


