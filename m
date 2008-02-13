Return-Path: <linux-kernel-owner+w=401wt.eu-S1765877AbYBMPez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765877AbYBMPez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbYBMPeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:34:46 -0500
Received: from sd-green-bigip-145.dreamhost.com ([208.97.132.145]:60218 "EHLO
	spunkymail-a10.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755963AbYBMPep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:34:45 -0500
X-Greylist: delayed 42845 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 10:34:45 EST
Message-ID: <47B30E11.2080903@sdiz.net>
Date: Wed, 13 Feb 2008 23:34:41 +0800
From: SDiZ <sdiz@sdiz.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][BLUETOOTH] add HCI_BROKEN_ISOC for 0e5e:6622 (bugzilla
 #9027)
References: <47B266AE.3040908@sdiz.net> <1202898692.7664.369.camel@violet>
In-Reply-To: <1202898692.7664.369.camel@violet>
Content-Type: text/plain; charset=Big5-HKSCS
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Marcel Holtmann wrote:
> Hi,
>   
>> This patch fix bugzilla #9027.
>> ``Syslog flooded with "hci_scodata_packet: hci0 SCO packet for unknown
>> connection handle 92" message"
>>
>> see http://bugzilla.kernel.org/show_bug.cgi?id=9027
>>     
>
> when we get the content of /proc/bus/usb/devices for this one. Do you
> have the manufacturer name of it or at least an idea which kind of
> device this is. Check "hciconfig hci0 version".
>   
It have no text on the chips and package, so I don't know the
manufacturer name.

/proc/bus/usb/devices shows:


T: Bus=01 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 2 Spd=12 MxCh= 0
D: Ver= 1.10 Cls=e0(unk. ) Sub=01 Prot=01 MxPS=16 #Cfgs= 1
P: Vendor=0e5e ProdID=6622 Rev= 1.34
C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
E: Ad=81(I) Atr=03(Int.) MxPS= 16 Ivl=1ms
E: Ad=82(I) Atr=02(Bulk) MxPS= 64 Ivl=0ms
E: Ad=02(O) Atr=02(Bulk) MxPS= 64 Ivl=0ms
I: If#= 1 Alt= 0 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
E: Ad=83(I) Atr=01(Isoc) MxPS= 0 Ivl=1ms
E: Ad=03(O) Atr=01(Isoc) MxPS= 0 Ivl=1ms
I: If#= 1 Alt= 1 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
E: Ad=83(I) Atr=01(Isoc) MxPS= 9 Ivl=1ms
E: Ad=03(O) Atr=01(Isoc) MxPS= 9 Ivl=1ms
I:* If#= 1 Alt= 2 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
E: Ad=83(I) Atr=01(Isoc) MxPS= 17 Ivl=1ms
E: Ad=03(O) Atr=01(Isoc) MxPS= 17 Ivl=1ms

> Dave, I don't think this is a broken dongle. I think he hits the case of
> eSCO versus SCO connection (the fallback to SCO case). I am working on
> the proper fix for that, but that is not as simple as it seems.
>
> Regards
>
> Marcel
>   
Regards,
Yuk-Pong, Cheng (SDiZ)

