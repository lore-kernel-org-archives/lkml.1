Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbYBSCPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbYBSCPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 21:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757954AbYBSCOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 21:14:48 -0500
Received: from sd-green-bigip-74.dreamhost.com ([208.97.132.74]:54157 "EHLO
	spunkymail-a19.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757564AbYBSCOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 21:14:47 -0500
Message-ID: <47BA3B91.1000508@sdiz.net>
Date: Tue, 19 Feb 2008 10:14:41 +0800
From: SDiZ <sdiz@sdiz.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
Cc: SDiZ <sdiz@sdiz.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][BLUETOOTH] add HCI_BROKEN_ISOC for 0e5e:6622 (bugzilla
 #9027)
References: <47B266AE.3040908@sdiz.net> <1202898692.7664.369.camel@violet>	 <47B30E11.2080903@sdiz.net> <1202917206.7664.417.camel@violet>
In-Reply-To: <1202917206.7664.417.camel@violet>
Content-Type: multipart/mixed;
 boundary="------------040805080505090704080305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040805080505090704080305
Content-Type: text/plain; charset=Big5-HKSCS
Content-Transfer-Encoding: 7bit

(resending this as i have got no reply in the last week)

Marcel Holtmann wrote:
> Hi,
>>>> This patch fix bugzilla #9027.
>>>> ``Syslog flooded with "hci_scodata_packet: hci0 SCO packet for unknown
>>>> connection handle 92" message"
>>>>
>>>> see http://bugzilla.kernel.org/show_bug.cgi?id=9027
>>>>     
>>> when we get the content of /proc/bus/usb/devices for this one. Do you
>>> have the manufacturer name of it or at least an idea which kind of
>>> device this is. Check "hciconfig hci0 version".
>>>   
>> It have no text on the chips and package, so I don't know the
>> manufacturer name.
>>     
> and what about "hciconfig hci0 version"?
>   

hci0: Type: USB
BD Address: 11:11:11:11:11:11 ACL MTU: 672:3 SCO MTU: 48:1
HCI Ver: 2.0 (0x3) HCI Rev: 0x1f4 LMP Ver: 2.0 (0x3) LMP Subver: 0x1f4
Manufacturer: CONWISE Technology Corporation Ltd (66)

>> /proc/bus/usb/devices shows:
>> [...]
>
> That is not all. Otherwise it is violating the Bluetooth HCI USB
> specification and we have bigger problems when switching USB alternate
> endpoints.
>   

hmm.. there are some entries for usb mouse and hubs, nothing else.
I have attached the whole file for your reference.

Other then the annoying syslog message, everything work fine.

> Regards
>
> Marcel
>
>
>   

Regards,
Yuk-Pong, Cheng (SDiZ)






--------------040805080505090704080305
Content-Type: text/plain;
 name="usb-device.txt"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="usb-device.txt"

ClQ6ICBCdXM9MDUgTGV2PTAwIFBybnQ9MDAgUG9ydD0wMCBDbnQ9MDAgRGV2Iz0gIDEgU3Bk
PTQ4MCBNeENoPSA4CkI6ICBBbGxvYz0gIDAvODAwIHVzICggMCUpLCAjSW50PSAgMCwgI0lz
bz0gIDAKRDogIFZlcj0gMi4wMCBDbHM9MDkoaHViICApIFN1Yj0wMCBQcm90PTAxIE14UFM9
NjQgI0NmZ3M9ICAxClA6ICBWZW5kb3I9MDAwMCBQcm9kSUQ9MDAwMCBSZXY9IDIuMDYKUzog
IE1hbnVmYWN0dXJlcj1MaW51eCAyLjYuMjQtMS02ODYgZWhjaV9oY2QKUzogIFByb2R1Y3Q9
RUhDSSBIb3N0IENvbnRyb2xsZXIKUzogIFNlcmlhbE51bWJlcj0wMDAwOjAwOjFkLjcKQzoq
ICNJZnM9IDEgQ2ZnIz0gMSBBdHI9ZTAgTXhQd3I9ICAwbUEKSToqIElmIz0gMCBBbHQ9IDAg
I0VQcz0gMSBDbHM9MDkoaHViICApIFN1Yj0wMCBQcm90PTAwIERyaXZlcj1odWIKRTogIEFk
PTgxKEkpIEF0cj0wMyhJbnQuKSBNeFBTPSAgIDQgSXZsPTI1Nm1zCgpUOiAgQnVzPTA0IExl
dj0wMCBQcm50PTAwIFBvcnQ9MDAgQ250PTAwIERldiM9ICAxIFNwZD0xMiAgTXhDaD0gMgpC
OiAgQWxsb2M9ICAwLzkwMCB1cyAoIDAlKSwgI0ludD0gIDAsICNJc289ICAwCkQ6ICBWZXI9
IDEuMTAgQ2xzPTA5KGh1YiAgKSBTdWI9MDAgUHJvdD0wMCBNeFBTPTY0ICNDZmdzPSAgMQpQ
OiAgVmVuZG9yPTAwMDAgUHJvZElEPTAwMDAgUmV2PSAyLjA2ClM6ICBNYW51ZmFjdHVyZXI9
TGludXggMi42LjI0LTEtNjg2IHVoY2lfaGNkClM6ICBQcm9kdWN0PVVIQ0kgSG9zdCBDb250
cm9sbGVyClM6ICBTZXJpYWxOdW1iZXI9MDAwMDowMDoxZC4zCkM6KiAjSWZzPSAxIENmZyM9
IDEgQXRyPWUwIE14UHdyPSAgMG1BCkk6KiBJZiM9IDAgQWx0PSAwICNFUHM9IDEgQ2xzPTA5
KGh1YiAgKSBTdWI9MDAgUHJvdD0wMCBEcml2ZXI9aHViCkU6ICBBZD04MShJKSBBdHI9MDMo
SW50LikgTXhQUz0gICAyIEl2bD0yNTVtcwoKVDogIEJ1cz0wMyBMZXY9MDAgUHJudD0wMCBQ
b3J0PTAwIENudD0wMCBEZXYjPSAgMSBTcGQ9MTIgIE14Q2g9IDIKQjogIEFsbG9jPSAgMC85
MDAgdXMgKCAwJSksICNJbnQ9ICAwLCAjSXNvPSAgMApEOiAgVmVyPSAxLjEwIENscz0wOSho
dWIgICkgU3ViPTAwIFByb3Q9MDAgTXhQUz02NCAjQ2Zncz0gIDEKUDogIFZlbmRvcj0wMDAw
IFByb2RJRD0wMDAwIFJldj0gMi4wNgpTOiAgTWFudWZhY3R1cmVyPUxpbnV4IDIuNi4yNC0x
LTY4NiB1aGNpX2hjZApTOiAgUHJvZHVjdD1VSENJIEhvc3QgQ29udHJvbGxlcgpTOiAgU2Vy
aWFsTnVtYmVyPTAwMDA6MDA6MWQuMgpDOiogI0lmcz0gMSBDZmcjPSAxIEF0cj1lMCBNeFB3
cj0gIDBtQQpJOiogSWYjPSAwIEFsdD0gMCAjRVBzPSAxIENscz0wOShodWIgICkgU3ViPTAw
IFByb3Q9MDAgRHJpdmVyPWh1YgpFOiAgQWQ9ODEoSSkgQXRyPTAzKEludC4pIE14UFM9ICAg
MiBJdmw9MjU1bXMKClQ6ICBCdXM9MDIgTGV2PTAwIFBybnQ9MDAgUG9ydD0wMCBDbnQ9MDAg
RGV2Iz0gIDEgU3BkPTEyICBNeENoPSAyCkI6ICBBbGxvYz0gNTYvOTAwIHVzICggNiUpLCAj
SW50PSAgMiwgI0lzbz0gIDEKRDogIFZlcj0gMS4xMCBDbHM9MDkoaHViICApIFN1Yj0wMCBQ
cm90PTAwIE14UFM9NjQgI0NmZ3M9ICAxClA6ICBWZW5kb3I9MDAwMCBQcm9kSUQ9MDAwMCBS
ZXY9IDIuMDYKUzogIE1hbnVmYWN0dXJlcj1MaW51eCAyLjYuMjQtMS02ODYgdWhjaV9oY2QK
UzogIFByb2R1Y3Q9VUhDSSBIb3N0IENvbnRyb2xsZXIKUzogIFNlcmlhbE51bWJlcj0wMDAw
OjAwOjFkLjEKQzoqICNJZnM9IDEgQ2ZnIz0gMSBBdHI9ZTAgTXhQd3I9ICAwbUEKSToqIElm
Iz0gMCBBbHQ9IDAgI0VQcz0gMSBDbHM9MDkoaHViICApIFN1Yj0wMCBQcm90PTAwIERyaXZl
cj1odWIKRTogIEFkPTgxKEkpIEF0cj0wMyhJbnQuKSBNeFBTPSAgIDIgSXZsPTI1NW1zCgpU
OiAgQnVzPTAyIExldj0wMSBQcm50PTAxIFBvcnQ9MDAgQ250PTAxIERldiM9ICA0IFNwZD0x
MiAgTXhDaD0gMApEOiAgVmVyPSAxLjEwIENscz1lMCh1bmsuICkgU3ViPTAxIFByb3Q9MDEg
TXhQUz0xNiAjQ2Zncz0gIDEKUDogIFZlbmRvcj0wZTVlIFByb2RJRD02NjIyIFJldj0gMS4z
NApDOiogI0lmcz0gMiBDZmcjPSAxIEF0cj04MCBNeFB3cj0xMDBtQQpJOiogSWYjPSAwIEFs
dD0gMCAjRVBzPSAzIENscz1lMCh1bmsuICkgU3ViPTAxIFByb3Q9MDEgRHJpdmVyPWhjaV91
c2IKRTogIEFkPTgxKEkpIEF0cj0wMyhJbnQuKSBNeFBTPSAgMTYgSXZsPTFtcwpFOiAgQWQ9
ODIoSSkgQXRyPTAyKEJ1bGspIE14UFM9ICA2NCBJdmw9MG1zCkU6ICBBZD0wMihPKSBBdHI9
MDIoQnVsaykgTXhQUz0gIDY0IEl2bD0wbXMKSTogIElmIz0gMSBBbHQ9IDAgI0VQcz0gMiBD
bHM9ZTAodW5rLiApIFN1Yj0wMSBQcm90PTAxIERyaXZlcj1oY2lfdXNiCkU6ICBBZD04MyhJ
KSBBdHI9MDEoSXNvYykgTXhQUz0gICAwIEl2bD0xbXMKRTogIEFkPTAzKE8pIEF0cj0wMShJ
c29jKSBNeFBTPSAgIDAgSXZsPTFtcwpJOiAgSWYjPSAxIEFsdD0gMSAjRVBzPSAyIENscz1l
MCh1bmsuICkgU3ViPTAxIFByb3Q9MDEgRHJpdmVyPWhjaV91c2IKRTogIEFkPTgzKEkpIEF0
cj0wMShJc29jKSBNeFBTPSAgIDkgSXZsPTFtcwpFOiAgQWQ9MDMoTykgQXRyPTAxKElzb2Mp
IE14UFM9ICAgOSBJdmw9MW1zCkk6KiBJZiM9IDEgQWx0PSAyICNFUHM9IDIgQ2xzPWUwKHVu
ay4gKSBTdWI9MDEgUHJvdD0wMSBEcml2ZXI9aGNpX3VzYgpFOiAgQWQ9ODMoSSkgQXRyPTAx
KElzb2MpIE14UFM9ICAxNyBJdmw9MW1zCkU6ICBBZD0wMyhPKSBBdHI9MDEoSXNvYykgTXhQ
Uz0gIDE3IEl2bD0xbXMKClQ6ICBCdXM9MDIgTGV2PTAxIFBybnQ9MDEgUG9ydD0wMSBDbnQ9
MDIgRGV2Iz0gIDMgU3BkPTEuNSBNeENoPSAwCkQ6ICBWZXI9IDEuMTAgQ2xzPTAwKD5pZmMg
KSBTdWI9MDAgUHJvdD0wMCBNeFBTPSA4ICNDZmdzPSAgMQpQOiAgVmVuZG9yPTA1ZTMgUHJv
ZElEPTEyMDUgUmV2PSAxLjEwClM6ICBQcm9kdWN0PVVTQiBNb3VzZQpDOiogI0lmcz0gMSBD
ZmcjPSAxIEF0cj1hMCBNeFB3cj0xMDBtQQpJOiogSWYjPSAwIEFsdD0gMCAjRVBzPSAxIENs
cz0wMyhISUQgICkgU3ViPTAxIFByb3Q9MDIgRHJpdmVyPXVzYmhpZApFOiAgQWQ9ODEoSSkg
QXRyPTAzKEludC4pIE14UFM9ICAgNCBJdmw9MTBtcwoKVDogIEJ1cz0wMSBMZXY9MDAgUHJu
dD0wMCBQb3J0PTAwIENudD0wMCBEZXYjPSAgMSBTcGQ9MTIgIE14Q2g9IDIKQjogIEFsbG9j
PSAgMC85MDAgdXMgKCAwJSksICNJbnQ9ICAwLCAjSXNvPSAgMApEOiAgVmVyPSAxLjEwIENs
cz0wOShodWIgICkgU3ViPTAwIFByb3Q9MDAgTXhQUz02NCAjQ2Zncz0gIDEKUDogIFZlbmRv
cj0wMDAwIFByb2RJRD0wMDAwIFJldj0gMi4wNgpTOiAgTWFudWZhY3R1cmVyPUxpbnV4IDIu
Ni4yNC0xLTY4NiB1aGNpX2hjZApTOiAgUHJvZHVjdD1VSENJIEhvc3QgQ29udHJvbGxlcgpT
OiAgU2VyaWFsTnVtYmVyPTAwMDA6MDA6MWQuMApDOiogI0lmcz0gMSBDZmcjPSAxIEF0cj1l
MCBNeFB3cj0gIDBtQQpJOiogSWYjPSAwIEFsdD0gMCAjRVBzPSAxIENscz0wOShodWIgICkg
U3ViPTAwIFByb3Q9MDAgRHJpdmVyPWh1YgpFOiAgQWQ9ODEoSSkgQXRyPTAzKEludC4pIE14
UFM9ICAgMiBJdmw9MjU1bXMK
--------------040805080505090704080305--
