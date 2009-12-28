Return-Path: <linux-kernel-owner+w=401wt.eu-S1751811AbZL1Ol7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbZL1Ol7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 09:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZL1Ol6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 09:41:58 -0500
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:49829 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649AbZL1Olz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 09:41:55 -0500
Message-ID: <4B38C3AF.1060509@blueyonder.co.uk>
Date: Mon, 28 Dec 2009 14:41:51 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0 ThunderBrowse/3.2.6.8
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: All kernels after 2.6.32-git10  show only 1 CPU ** NOT Fixed
 in 2.6.33-rc2 either **
References: <4B324B76.9020901@blueyonder.co.uk> <4B33670C.7050503@blueyonder.co.uk> <4B341149.9010106@blueyonder.co.uk> <4B363EEE.8020108@blueyonder.co.uk> <alpine.LFD.2.00.0912261457550.4089@localhost.localdomain> <4B37F16D.1040000@blueyonder.co.uk> <4B37F3F8.5000108@blueyonder.co.uk>
In-Reply-To: <4B37F3F8.5000108@blueyonder.co.uk>
Content-Type: multipart/mixed;
 boundary="------------000707040900010400080204"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000707040900010400080204
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I'm attaching dmesg. Booted linux-next 20091228 with "lapic acpi=ht",
acpi=ht gets over the solid lock up on HDA intel line as shown below. In
dmesg it's saying this is not a SMP motherboard - it's an Asus M2N32-SLI
deluxe with a 64X2, yet every kernel up to 2.6.32-git1 is fine with 2
CPU's. BIOS updated a few months ago, will check if a later one is
available.
The lock up
============
ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 21
HDA Intel 0000:00:0e.1: PCI INT B -> Link[AAZA] -> GSI 21 (level, low)
-> IRQ 21.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

--------------000707040900010400080204
Content-Type: application/http-index-format
Content-Transfer-Encoding: base64

MzAwOiBmaWxlOi8vLwoyMDA6IGZpbGVuYW1lIGNvbnRlbnQtbGVuZ3RoIGxhc3QtbW9kaWZp
ZWQgZmlsZS10eXBlCjIwMTogLmNvbmZpZ19iZWFnbGVib2FyZCA2MDI5NyBUaHUsJTIwMjkl
MjBPY3QlMjAyMDA5JTIwMDI6MDI6NTQlMjBHTVQgRklMRSAKMjAxOiAuY29uZmlnX2RzczIg
NjE1NDggRnJpLCUyMDA2JTIwTm92JTIwMjAwOSUyMDEzOjEzOjQ2JTIwR01UIEZJTEUgCjIw
MTogLmphY2tkcmMgNjUgVHVlLCUyMDI1JTIwQXVnJTIwMjAwOSUyMDAxOjI0OjM1JTIwR01U
IEZJTEUgCjIwMTogMC5wb29sLm50cC5vcmcgMTMgVGh1LCUyMDI5JTIwT2N0JTIwMjAwOSUy
MDAwOjM5OjQwJTIwR01UIEZJTEUgCjIwMTogMSAwIFRodSwlMjAyMCUyMEF1ZyUyMDIwMDkl
MjAyMTo1NToxOSUyMEdNVCBESVJFQ1RPUlkgCjIwMTogMiAwIFRodSwlMjAyMCUyMEF1ZyUy
MDIwMDklMjAyMTo1NToyMyUyMEdNVCBESVJFQ1RPUlkgCjIwMTogMi42LjMyLXJjNS1naXQ0
LW9tYXAub3V0IDg0NTk2IFNhdCwlMjAzMSUyME9jdCUyMDIwMDklMjAwNTozNDo1MCUyMEdN
VCBGSUxFIAoyMDE6IDIuNi4zMi1yYzUtb21hcC5vdXQgMjEzNyBGcmksJTIwMzAlMjBPY3Ql
MjAyMDA5JTIwMTE6NDA6MTMlMjBHTVQgRklMRSAKMjAxOiA1MC1zb3VuZC5jb25mIDIwOCBT
YXQsJTIwMjElMjBOb3YlMjAyMDA5JTIwMjM6MTg6MzElMjBHTVQgRklMRSAKMjAxOiA1Mi11
c3gyeWF1ZGlvLnJ1bGVzIDEyODEgU3VuLCUyMDEzJTIwRGVjJTIwMjAwOSUyMDIxOjU5OjU0
JTIwR01UIEZJTEUgCjIwMTogQVBMQVlfRVJSIDMzNyBTYXQsJTIwMjUlMjBKdWwlMjAyMDA5
JTIwMTQ6MDc6MzglMjBHTVQgRklMRSAKMjAxOiBBUlRJQ0xFUyAwIFN1biwlMjAxOSUyMEp1
bCUyMDIwMDklMjAyMjoyMTowNyUyMEdNVCBESVJFQ1RPUlkgCjIwMTogQkFTSFJDIDE1NyBT
YXQsJTIwMjklMjBBdWclMjAyMDA5JTIwMTE6MzA6NTMlMjBHTVQgRklMRSAKMjAxOiBCQi5v
dXQgMzk1MiBNb24sJTIwMjYlMjBPY3QlMjAyMDA5JTIwMTY6NDI6MDElMjBHTVQgRklMRSAK
MjAxOiBCQl9wcmVwIDQ0NiBUaHUsJTIwMTUlMjBPY3QlMjAyMDA5JTIwMDE6Mjc6NTElMjBH
TVQgRklMRSAKMjAxOiBCQl9wcmVwMiAzMTIgVGh1LCUyMDE1JTIwT2N0JTIwMjAwOSUyMDAx
OjM2OjA1JTIwR01UIEZJTEUgCjIwMTogQkVBR0xFQk9BUkQgMCBGcmksJTIwMjElMjBBdWcl
MjAyMDA5JTIwMDA6NDg6NDElMjBHTVQgRElSRUNUT1JZIAoyMDE6IEJFQUdMRV9LRVJORUwg
MCBTdW4sJTIwMDElMjBOb3YlMjAyMDA5JTIwMDA6MDc6NTQlMjBHTVQgRElSRUNUT1JZIAoy
MDE6IEJJVEJBS0UuU1RVRkYgMTQ3OCBNb24sJTIwMjYlMjBPY3QlMjAyMDA5JTIwMDE6NTI6
NTYlMjBHTVQgRklMRSAKMjAxOiBCT09UX2dydWIudGFyLmJ6MiAxMDA4MjUgRnJpLCUyMDI4
JTIwQXVnJTIwMjAwOSUyMDA4OjM5OjAyJTIwR01UIEZJTEUgCjIwMTogQ09OU09MRS5vdXQg
Mzc4IFdlZCwlMjAxMSUyME5vdiUyMDIwMDklMjAyMzoyMDoyNiUyMEdNVCBGSUxFIAoyMDE6
IENlbnRPUy5xY293MiA0MjE4ODggVGh1LCUyMDIzJTIwQXByJTIwMjAwOSUyMDE5OjU5OjE2
JTIwR01UIEZJTEUgCjIwMTogREhDUF9CRUdMRSAxMDEgVHVlLCUyMDExJTIwQXVnJTIwMjAw
OSUyMDAyOjI4OjI4JTIwR01UIEZJTEUgCjIwMTogREtNU19WQk9YIDE3ODMgRnJpLCUyMDE2
JTIwT2N0JTIwMjAwOSUyMDEzOjI5OjMxJTIwR01UIEZJTEUgCjIwMTogRE1FU0dfQkVBR0xF
IDEzMDY5IFdlZCwlMjAxMSUyME5vdiUyMDIwMDklMjAyMjoxNDowNyUyMEdNVCBGSUxFIAoy
MDE6IERNRVNHX0JlYWdsZSAxNTY4NSBXZWQsJTIwMTklMjBBdWclMjAyMDA5JTIwMDk6Mjg6
MzAlMjBHTVQgRklMRSAKMjAxOiBETUVTR19zbGlwc3RyZWFtIDI3MzUgRnJpLCUyMDI1JTIw
RGVjJTIwMjAwOSUyMDAwOjI3OjMwJTIwR01UIEZJTEUgCjIwMTogRE1FU0dfdGluZG9nIDI4
ODc2IE1vbiwlMjAyOCUyMERlYyUyMDIwMDklMjAxNDozMDoyOSUyMEdNVCBGSUxFIAoyMDE6
IEVUSDBfYmVhZ2xlYm9hcmQgODI3IE1vbiwlMjAxMiUyME9jdCUyMDIwMDklMjAwMjoyMToy
NCUyMEdNVCBGSUxFIAoyMDE6IEZCLm91dCA4NTAgV2VkLCUyMDExJTIwTm92JTIwMjAwOSUy
MDIzOjExOjE1JTIwR01UIEZJTEUgCjIwMTogRkJfT01BUCA1MDEgV2VkLCUyMDA0JTIwTm92
JTIwMjAwOSUyMDAwOjMwOjU2JTIwR01UIEZJTEUgCjIwMTogRkQwZXJyIDM2MCBUdWUsJTIw
MjUlMjBBdWclMjAyMDA5JTIwMjE6MDc6NDglMjBHTVQgRklMRSAKMjAxOiBGRUQxMiAwIFR1
ZSwlMjAxNyUyME5vdiUyMDIwMDklMjAxNToxOToyNCUyMEdNVCBESVJFQ1RPUlkgCjIwMTog
RkVEX2ZzdGFiIDc3OSBTdW4sJTIwMjIlMjBOb3YlMjAyMDA5JTIwMjA6NTI6MDElMjBHTVQg
RklMRSAKMjAxOiBGTEFTSF9FUlIgNTYwIFNhdCwlMjAyNSUyMEp1bCUyMDIwMDklMjAxNDow
MzowOCUyMEdNVCBGSUxFIAoyMDE6IEZTVEFCX3RpbmRvZyA4NzggU3VuLCUyMDE5JTIwQXBy
JTIwMjAwOSUyMDE1OjAzOjM1JTIwR01UIEZJTEUgCjIwMTogRmVkb3JhMTIueG1sIDQyMjUg
U2F0LCUyMDE0JTIwTm92JTIwMjAwOSUyMDEwOjMyOjQ3JTIwR01UIEZJTEUgCjIwMTogR1JV
Qi50YXIuYnoyIDEwODA0MSBGcmksJTIwMDIlMjBPY3QlMjAyMDA5JTIwMjM6NTI6NTYlMjBH
TVQgRklMRSAKMjAxOiBIQU1SQURJTyAwIFR1ZSwlMjAxNiUyMERlYyUyMDIwMDglMjAyMDo0
NTowMiUyMEdNVCBESVJFQ1RPUlkgCjIwMTogSEFSRFdBUkVfTUFOVUFMUyAwIFN1biwlMjAw
MyUyME1heSUyMDIwMDklMjAyMzoxNTozMSUyMEdNVCBESVJFQ1RPUlkgCjIwMTogSFdJTkZP
IDc5MjY0NSBNb24sJTIwMjclMjBKdWwlMjAyMDA5JTIwMTA6NDA6NDAlMjBHTVQgRklMRSAK
MjAxOiBJU08gMCBGcmksJTIwMTElMjBEZWMlMjAyMDA5JTIwMTc6MTQ6NDElMjBHTVQgRElS
RUNUT1JZIAoyMDE6IEpBQ0tNUF9LVUJVTlRVIDUwOSBNb24sJTIwMDclMjBEZWMlMjAyMDA5
JTIwMTc6MDI6MTYlMjBHTVQgRklMRSAKMjAxOiBKQUNLX0RFUFMgMzQ3IFN1biwlMjAwMyUy
ME1heSUyMDIwMDklMjAwMDowOTo1MiUyMEdNVCBGSUxFIAoyMDE6IEtFWVMgMCBTdW4sJTIw
MjAlMjBEZWMlMjAyMDA5JTIwMTg6NTE6MTclMjBHTVQgRElSRUNUT1JZIAoyMDE6IE1FUElT
LmltZyAyMTQ3NDc5NTUyMCBXZWQsJTIwMjklMjBKdWwlMjAyMDA5JTIwMjM6NTk6MzYlMjBH
TVQgRklMRSAKMjAxOiBNVUxUSVBMRV9QUk9WSURFUlMgMzIyOSBNb24sJTIwMjYlMjBPY3Ql
MjAyMDA5JTIwMTQ6NDQ6MDglMjBHTVQgRklMRSAKMjAxOiBNVVNCX0VSUiA4MDEgU3VuLCUy
MDAxJTIwTm92JTIwMjAwOSUyMDIzOjI2OjU2JTIwR01UIEZJTEUgCjIwMTogT00xNDEwIDEz
MTA3MiBXZWQsJTIwMTQlMjBPY3QlMjAyMDA5JTIwMTI6MDA6MDAlMjBHTVQgRklMRSAKMjAx
OiBPTUFQIDE5MDg1IFdlZCwlMjAxOCUyME5vdiUyMDIwMDklMjAxMjoxNjoxNSUyMEdNVCBG
SUxFIAoyMDE6IE9NQVAzX1BBVENIRVNfTUlTU0lORyA3NTEgVGh1LCUyMDE3JTIwRGVjJTIw
MjAwOSUyMDAxOjI1OjI1JTIwR01UIEZJTEUgCjIwMTogT01BUF9GQl9CVUlMRF9FUlIgMTM5
NCBTYXQsJTIwMDclMjBOb3YlMjAyMDA5JTIwMDA6MjI6MTQlMjBHTVQgRklMRSAKMjAxOiBP
TUFQX0dJVCA4MyBTdW4sJTIwMDQlMjBPY3QlMjAyMDA5JTIwMjI6NDI6MTUlMjBHTVQgRklM
RSAKMjAxOiBPTUFQX05FVyAxMzEwNzIgU2F0LCUyMDAzJTIwT2N0JTIwMjAwOSUyMDAzOjMz
OjExJTIwR01UIEZJTEUgCjIwMTogT01BUF9ORVcyIDEzMTA3MiBTdW4sJTIwMDQlMjBPY3Ql
MjAyMDA5JTIwMTI6MzI6MDclMjBHTVQgRklMRSAKMjAxOiBPTUFQX05FVzMgMTMxMDcyIFN1
biwlMjAwNCUyME9jdCUyMDIwMDklMjAxODo0Mjo1NyUyMEdNVCBGSUxFIAoyMDE6IE9NQVBf
bGF0ZXN0IDEzMTA3MiBUdWUsJTIwMjIlMjBTZXAlMjAyMDA5JTIwMDg6MDM6NTklMjBHTVQg
RklMRSAKMjAxOiBPTUFQX3Vuc3RhYmxlIDIwMDg1IEZyaSwlMjAyNSUyMFNlcCUyMDIwMDkl
MjAwOTo1NjoyNCUyMEdNVCBGSUxFIAoyMDE6IE9NQVBfdW5zdGFibGUyIDQxMTk5IEZyaSwl
MjAyNSUyMFNlcCUyMDIwMDklMjAxMToxMToyOCUyMEdNVCBGSUxFIAoyMDE6IE9NQVBfd3NQ
eXRob24gMTMxMDcyIFdlZCwlMjAyMSUyME9jdCUyMDIwMDklMjAyMDoyNTowMyUyMEdNVCBG
SUxFIAoyMDE6IE9QRU5XUlQgMCBTYXQsJTIwMTYlMjBNYXklMjAyMDA5JTIwMTM6Mjk6NTUl
MjBHTVQgRElSRUNUT1JZIAoyMDE6IFBVTFNFX1JFU1RBUlQuZ3ogMzg2MSBUaHUsJTIwMjcl
MjBBdWclMjAyMDA5JTIwMDk6NDc6NTclMjBHTVQgRklMRSAKMjAxOiBQWV9XWEdUSyA3NTAg
RnJpLCUyMDE4JTIwU2VwJTIwMjAwOSUyMDEyOjA1OjQzJTIwR01UIEZJTEUgCjIwMTogUUNP
VzIgMCBNb24sJTIwMjUlMjBNYXklMjAyMDA5JTIwMjI6MDU6MTAlMjBHTVQgRElSRUNUT1JZ
IAoyMDE6IFFVSVNLLm91dC5neiAxODkyIFN1biwlMjAwMSUyME5vdiUyMDIwMDklMjAwMDoy
ODowOSUyMEdNVCBGSUxFIAoyMDE6IFNEUiAwIFRodSwlMjAyMCUyMEF1ZyUyMDIwMDklMjAw
ODo1NDozMSUyMEdNVCBESVJFQ1RPUlkgCjIwMTogU0RSLm91dCAxOTYwIFN1biwlMjAyMyUy
MEF1ZyUyMDIwMDklMjAxOTo1Nzo1MSUyMEdNVCBGSUxFIAoyMDE6IFNFTlNPUlMgNDIxIFN1
biwlMjAxOSUyMEFwciUyMDIwMDklMjAxNDo0Njo0NiUyMEdNVCBGSUxFIAoyMDE6IFNQRUNf
RklMRSA1NjkgU3VuLCUyMDE3JTIwTWF5JTIwMjAwOSUyMDIyOjU2OjM2JTIwR01UIEZJTEUg
CjIwMTogU1ZOIDcyIFRodSwlMjAxOSUyME5vdiUyMDIwMDklMjAwMjoxODowNSUyMEdNVCBG
SUxFIAoyMDE6IFNpNTcwX0NvbnRyb2xsZXJfd2l0aF9Tb2Z0cm9jay50eHQgNDA1NyBUaHUs
JTIwMDclMjBNYXklMjAyMDA5JTIwMTY6NDk6MjElMjBHTVQgRklMRSAKMjAxOiBUVVRPUklB
TFMgMCBUaHUsJTIwMjYlMjBOb3YlMjAyMDA5JTIwMDA6MzU6NTIlMjBHTVQgRElSRUNUT1JZ
IAoyMDE6IFZCb3hHdWVzdEFkZGl0aW9uc18zLjEuMC5pc28gMzM3Nzk3MTIgU2F0LCUyMDEy
JTIwRGVjJTIwMjAwOSUyMDAwOjU1OjU5JTIwR01UIEZJTEUgCjIwMTogVklSVFVBTEJPWC50
YXIuYnoyIDMyOTkzMjI1IEZyaSwlMjAyMyUyME9jdCUyMDIwMDklMjAxOToxMjowMiUyMEdN
VCBGSUxFIAoyMDE6IFdMQU5fRXJyb3IgMTg0IFdlZCwlMjAyMyUyMFNlcCUyMDIwMDklMjAx
MzoxMjoxNyUyMEdNVCBGSUxFIAoyMDE6IFdQQV9iZWFnbGVib2FyZCA1OTMyIFN1biwlMjAw
NCUyME9jdCUyMDIwMDklMjAxOTowODo1NiUyMEdNVCBGSUxFIAoyMDE6IFdQQV9jb25maWdf
QmVhZ2xlYm9hcmQgMTg1IFN1biwlMjAwNCUyME9jdCUyMDIwMDklMjAyMTo0OToyMyUyMEdN
VCBGSUxFIAoyMDE6IFdWRElBTC5vdXQgMTk3NCBGcmksJTIwMDIlMjBPY3QlMjAyMDA5JTIw
MjM6NDc6MDIlMjBHTVQgRklMRSAKMjAxOiBXWF9QWSAxMzEwNzIgVHVlLCUyMDI0JTIwTm92
JTIwMjAwOSUyMDAwOjA1OjE3JTIwR01UIEZJTEUgCjIwMTogWERQWUlORk9fQkVBR0xFIDI0
NzIgVHVlLCUyMDIyJTIwU2VwJTIwMjAwOSUyMDA4OjE3OjU3JTIwR01UIEZJTEUgCjIwMTog
WE9SRyAwIEZyaSwlMjAzMCUyME9jdCUyMDIwMDklMjAxMToyNjoxNiUyMEdNVCBESVJFQ1RP
UlkgCjIwMTogWE9SR19CRUFHTEUgMjY1NSBNb24sJTIwMjQlMjBBdWclMjAyMDA5JTIwMDk6
NDg6MTMlMjBHTVQgRklMRSAKMjAxOiBYb3JnLjAubG9nX2JlYWdsZSA4OTAzIFR1ZSwlMjAx
OCUyMEF1ZyUyMDIwMDklMjAwMDozNToyNyUyMEdNVCBGSUxFIAoyMDE6IGFwcGNhY2hlIDAg
U2F0LCUyMDExJTIwSnVsJTIwMjAwOSUyMDIwOjU4OjU2JTIwR01UIERJUkVDVE9SWSAKMjAx
OiBhc291bmRyY19NLUF1ZGlvNDQgMTM5IFR1ZSwlMjAxMSUyMEF1ZyUyMDIwMDklMjAwMzow
ODoyMCUyMEdNVCBGSUxFIAoyMDE6IGJlYWdsZV93cGFfc3VwcGxpY2FudC5jb25mIDI0MyBT
dW4sJTIwMDklMjBBdWclMjAyMDA5JTIwMjE6MTQ6MTUlMjBHTVQgRklMRSAKMjAxOiBiaW4g
MCBNb24sJTIwMTQlMjBEZWMlMjAyMDA5JTIwMTE6MTM6MDAlMjBHTVQgRElSRUNUT1JZIAoy
MDE6IGJvb3QgMCBGcmksJTIwMjUlMjBEZWMlMjAyMDA5JTIwMDA6MjE6NTAlMjBHTVQgRElS
RUNUT1JZIAoyMDE6IGNkcm9tMyAwIEZyaSwlMjAwNSUyMEp1biUyMDIwMDklMjAyMzoyNzoz
OCUyMEdNVCBESVJFQ1RPUlkgCjIwMTogY29uZmlnLmd6IDE1ODEzIFdlZCwlMjAxMSUyME5v
diUyMDIwMDklMjAyMzo0MDoyNyUyMEdNVCBGSUxFIAoyMDE6IGNvbmZpZ19iZWFnbGVib2Fy
ZCA2MDI5NyBXZWQsJTIwMjglMjBPY3QlMjAyMDA5JTIwMDM6MjY6NDklMjBHTVQgRklMRSAK
MjAxOiBkYXRhMSAwIFdlZCwlMjAxMyUyME1heSUyMDIwMDklMjAxNTo0Njo1MSUyMEdNVCBE
SVJFQ1RPUlkgCjIwMTogZGV2IDAgTW9uLCUyMDI4JTIwRGVjJTIwMjAwOSUyMDEzOjIyOjEy
JTIwR01UIERJUkVDVE9SWSAKMjAxOiBkaGNwY2Qtd2xhbjAuaW5mbyA0MTIgVGh1LCUyMDE2
JTIwSnVsJTIwMjAwOSUyMDAwOjE0OjEyJTIwR01UIEZJTEUgCjIwMTogZGttcyAxMjMwMDkg
TW9uLCUyMDI0JTIwU2VwJTIwMjAwNyUyMDIyOjQ4OjI0JTIwR01UIEZJTEUgCjIwMTogZG90
X2NvbmZpZy1kc3MyIDI3Njc5IEZyaSwlMjAwNiUyME5vdiUyMDIwMDklMjAxMzoyNzoxNCUy
MEdNVCBGSUxFIAoyMDE6IGV0YyAwIE1vbiwlMjAyOCUyMERlYyUyMDIwMDklMjAxMzoxNjow
NSUyMEdNVCBESVJFQ1RPUlkgCjIwMTogZnN0YWIgODQyIFN1biwlMjAxOSUyMEFwciUyMDIw
MDklMjAwMzowNjozMyUyMEdNVCBGSUxFIAoyMDE6IGdydWJfcmVwYWlyIDkyOSBUaHUsJTIw
MDYlMjBBdWclMjAyMDA5JTIwMjM6MTM6NTAlMjBHTVQgRklMRSAKMjAxOiBob21lIDAgU2F0
LCUyMDEyJTIwRGVjJTIwMjAwOSUyMDA0OjM4OjQxJTIwR01UIERJUkVDVE9SWSAKMjAxOiBo
b3N0cyA5NjQgVGh1LCUyMDIzJTIwQXByJTIwMjAwOSUyMDAxOjAxOjU1JTIwR01UIEZJTEUg
CjIwMTogaWRfcnNhIDE2NzUgVHVlLCUyMDE3JTIwTm92JTIwMjAwOSUyMDE2OjAyOjM2JTIw
R01UIEZJTEUgCjIwMTogaWRfcnNhLnB1YiAzOTcgVHVlLCUyMDE3JTIwTm92JTIwMjAwOSUy
MDE2OjAyOjM2JTIwR01UIEZJTEUgCjIwMTogaWZjZmctYnIxIDIxNSBGcmksJTIwMzAlMjBP
Y3QlMjAyMDA5JTIwMDY6MTU6MzQlMjBHTVQgRklMRSAKMjAxOiBpZmNmZy13bGFuMCAyNzMx
MSBNb24sJTIwMjQlMjBBdWclMjAyMDA5JTIwMDM6MjM6MzElMjBHTVQgRklMRSAKMjAxOiBp
cGtnLWJ1aWxkX2VyciA1MTAgTW9uLCUyMDI2JTIwT2N0JTIwMjAwOSUyMDE0OjM5OjIxJTIw
R01UIEZJTEUgCjIwMTogamV0LndhdiAzNDg5MCBUaHUsJTIwMDklMjBKdWwlMjAyMDA5JTIw
MDM6MjE6MzclMjBHTVQgRklMRSAKMjAxOiBsaWIgMCBNb24sJTIwMTQlMjBEZWMlMjAyMDA5
JTIwMTA6NTM6MzclMjBHTVQgRElSRUNUT1JZIAoyMDE6IGxpYjY0IDAgTW9uLCUyMDE0JTIw
RGVjJTIwMjAwOSUyMDExOjExOjI1JTIwR01UIERJUkVDVE9SWSAKMjAxOiBsaW51eC0yLjYu
MzItcmM1LW9tYXAtZHNzMi50YXIuYnoyIDQ2NjAxNjI2NyBXZWQsJTIwMDQlMjBOb3YlMjAy
MDA5JTIwMTE6MzQ6MjUlMjBHTVQgRklMRSAKMjAxOiBsaW51eDI2LW9tYXBfYnVpbGRfZXJy
b3IgMjA3OSBXZWQsJTIwMjglMjBPY3QlMjAyMDA5JTIwMDI6Mzg6MTQlMjBHTVQgRklMRSAK
MjAxOiBsb2NhbC5jb25mIDc0MjcgTW9uLCUyMDI2JTIwT2N0JTIwMjAwOSUyMDE2OjQyOjI5
JTIwR01UIEZJTEUgCjIwMTogbWVkaWEgMCBTdW4sJTIwMjAlMjBEZWMlMjAyMDA5JTIwMTY6
Mjc6MDklMjBHTVQgRElSRUNUT1JZIAoyMDE6IG1lbWNvbnRyb2wuYyA2NTM1MCBTYXQsJTIw
MTElMjBKdWwlMjAyMDA5JTIwMDI6MzQ6MDglMjBHTVQgRklMRSAKMjAxOiBtZW1jb250cm9s
LmMuZGlmZiAzMzIgU2F0LCUyMDExJTIwSnVsJTIwMjAwOSUyMDAyOjM2OjE5JTIwR01UIEZJ
TEUgCjIwMTogbWVtY29udHJvbC5jX29yaWcgNjUzMjQgU2F0LCUyMDExJTIwSnVsJTIwMjAw
OSUyMDAyOjM1OjA0JTIwR01UIEZJTEUgCjIwMTogbWVudS5sc3QgMjcwMiBUdWUsJTIwMjUl
MjBBdWclMjAyMDA5JTIwMjE6NTU6NTQlMjBHTVQgRklMRSAKMjAxOiBtbnQgMCBTYXQsJTIw
MTIlMjBEZWMlMjAyMDA5JTIwMDQ6Mzg6NDElMjBHTVQgRElSRUNUT1JZIAoyMDE6IG8gMTQ3
ODEgRnJpLCUyMDA2JTIwTm92JTIwMjAwOSUyMDAzOjAxOjEwJTIwR01UIEZJTEUgCjIwMTog
by1kc3MyIDE0NTMzIEZyaSwlMjAwNiUyME5vdiUyMDIwMDklMjAxNjoyMDowNSUyMEdNVCBG
SUxFIAoyMDE6IG9lX2J1aWxkIDEyMDkxIE1vbiwlMjAyNiUyME9jdCUyMDIwMDklMjAwMzox
NTowMCUyMEdNVCBGSUxFIAoyMDE6IG9lX2dpdC5vdXQgNTQ5IE1vbiwlMjAyNiUyME9jdCUy
MDIwMDklMjAxNDo1MDo0MCUyMEdNVCBGSUxFIAoyMDE6IG9tXzIgMTMxMDcyIEZyaSwlMjAw
OSUyME9jdCUyMDIwMDklMjAxMjo0MTo1NCUyMEdNVCBGSUxFIAoyMDE6IG9tX2xhdGVzdCA2
MDUwMSBUaHUsJTIwMjQlMjBTZXAlMjAyMDA5JTIwMjE6MDQ6NDAlMjBHTVQgRklMRSAKMjAx
OiBvbWFwXzIuNi4zMi1yYzYgNzkyNzMgRnJpLCUyMDA2JTIwTm92JTIwMjAwOSUyMDIzOjIy
OjI1JTIwR01UIEZJTEUgCjIwMTogb3B0IDAgVGh1LCUyMDI0JTIwRGVjJTIwMjAwOSUyMDIw
OjE1OjA2JTIwR01UIERJUkVDVE9SWSAKMjAxOiBvc29sMDkwNi5xY293MiA4MzE0ODggU3Vu
LCUyMDI2JTIwSnVsJTIwMjAwOSUyMDE4OjAxOjU5JTIwR01UIEZJTEUgCjIwMTogcHJvYyAw
IE1vbiwlMjAyOCUyMERlYyUyMDIwMDklMjAxMzoxMzo1OCUyMEdNVCBESVJFQ1RPUlkgCjIw
MTogcHl0aC5jb25maWcgMjc5MiBUaHUsJTIwMTklMjBOb3YlMjAyMDA5JTIwMTU6NTQ6NDQl
MjBHTVQgRklMRSAKMjAxOiBxdWlzay5weSA3MzU5NyBUaHUsJTIwMDQlMjBKdW4lMjAyMDA5
JTIwMTk6MTI6NDElMjBHTVQgRklMRSAKMjAxOiBxdWlza19jb25maWcucHlfZ3JhZW1ldmog
NzA5OSBUaHUsJTIwMzAlMjBBcHIlMjAyMDA5JTIwMDA6MjY6NDIlMjBHTVQgRklMRSAKMjAx
OiByb290IDAgTW9uLCUyMDI4JTIwRGVjJTIwMjAwOSUyMDE0OjMyOjEzJTIwR01UIERJUkVD
VE9SWSAKMjAxOiBydDJ4eC5jb25mIDMzNiBUdWUsJTIwMTAlMjBOb3YlMjAyMDA5JTIwMjA6
NTY6NDIlMjBHTVQgRklMRSAKMjAxOiBzYmluIDAgRnJpLCUyMDI1JTIwRGVjJTIwMjAwOSUy
MDAwOjMxOjU2JTIwR01UIERJUkVDVE9SWSAKMjAxOiBzZWxpbnV4IDAgU2F0LCUyMDEyJTIw
RGVjJTIwMjAwOSUyMDA0OjM4OjQyJTIwR01UIERJUkVDVE9SWSAKMjAxOiBzaGFyZSAwIFR1
ZSwlMjAyNyUyME9jdCUyMDIwMDklMjAwMTo1ODoyOSUyMEdNVCBESVJFQ1RPUlkgCjIwMTog
c3J2IDAgU2F0LCUyMDEyJTIwRGVjJTIwMjAwOSUyMDA0OjM4OjQyJTIwR01UIERJUkVDVE9S
WSAKMjAxOiBzeXMgMCBNb24sJTIwMjglMjBEZWMlMjAyMDA5JTIwMTM6MTM6NTglMjBHTVQg
RElSRUNUT1JZIAoyMDE6IHRtcCAwIE1vbiwlMjAyOCUyMERlYyUyMDIwMDklMjAxNDo0MTo1
MSUyMEdNVCBESVJFQ1RPUlkgCjIwMTogdHJhbnNhY3Rpb25zLmRiIDkyMTYgV2VkLCUyMDI0
JTIwSnVuJTIwMjAwOSUyMDIyOjMxOjAzJTIwR01UIEZJTEUgCjIwMTogdXNicmVzZXQuYyA2
ODAgV2VkLCUyMDE0JTIwT2N0JTIwMjAwOSUyMDAxOjA1OjI5JTIwR01UIEZJTEUgCjIwMTog
dXNyIDAgTW9uLCUyMDE0JTIwRGVjJTIwMjAwOSUyMDExOjA0OjAyJTIwR01UIERJUkVDVE9S
WSAKMjAxOiB2YXIgMCBNb24sJTIwMTQlMjBEZWMlMjAyMDA5JTIwMDk6NDg6NTMlMjBHTVQg
RElSRUNUT1JZIAoyMDE6IHdlZWRzIDAgTW9uLCUyMDI4JTIwRGVjJTIwMjAwOSUyMDAyOjQw
OjQ3JTIwR01UIERJUkVDVE9SWSAKMjAxOiB3cGFfc3VwcGxpY2FudC5jb25mIDI3MCBNb24s
JTIwMDMlMjBBdWclMjAyMDA5JTIwMTM6NTU6MTAlMjBHTVQgRklMRSAKMjAxOiB3eEdUS19F
UlJPUl9iZWFnbGVfYW5kX29wZW5zdXNlIDYwNjIgV2VkLCUyMDIxJTIwT2N0JTIwMjAwOSUy
MDA2OjUxOjQzJTIwR01UIEZJTEUgCjIwMTogd3hXaWRnZXRzIDAgV2VkLCUyMDIxJTIwT2N0
JTIwMjAwOSUyMDE2OjAzOjMzJTIwR01UIERJUkVDVE9SWSAKMjAxOiB4b3JnLmNvbmYgNDI1
NiBGcmksJTIwMTYlMjBPY3QlMjAyMDA5JTIwMTM6MzQ6MTglMjBHTVQgRklMRSAKMjAxOiB4
b3JnLmNvbmZfQkVBR0xFQk9BUkQgNTMzMyBGcmksJTIwMTglMjBTZXAlMjAyMDA5JTIwMTE6
MTA6MzMlMjBHTVQgRklMRSAK
--------------000707040900010400080204
Content-Type: text/plain;
 name="DMESG_tindog"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="DMESG_tindog"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.33-rc2-next-next-20091228-smp (root@tindog) (gcc version 4.4.2 [gcc-4_4-branch revision 154496] (SUSE Linux) ) #1 SMP Mon Dec 28 04:51:14 GMT 2009
Command line: root=/dev/disk/by-id/scsi-SATA_WDC_WD10EAVS-32_WD-WCAU46493538-part1 resume=/dev/disk/by-id/scsi-SATA_WDC_WD10EAVS-32_WD-WCAU46493538-part3 splash=silent vga=0x31a lapic acpi=ht 3
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
 BIOS-e820: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
 BIOS-e820: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
 BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
NX (Execute Disable) protection: active
MPS support code is not built-in.
Using acpi=off or acpi=noirq or pci=noacpi may have problem
DMI 2.4 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
No AGP bridge found
last_pfn = 0x120000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 0000000000 mask FF80000000 write-back
  1 base 0080000000 mask FFC0000000 write-back
  2 base 00C0000000 mask FFE0000000 write-back
  3 base 00DFF00000 mask FFFFF00000 uncachable
  4 base 0100000000 mask FFE0000000 write-back
  5 disabled
  6 disabled
  7 disabled
TOM2: 0000000120000000 aka 4608M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000dff00000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xdfee0 max_arch_pfn = 0x400000000
Scanning 0 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 000000000009f000 (usable)
 modified: 000000000009f000 - 00000000000a0000 (reserved)
 modified: 00000000000f0000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 00000000dfee0000 (usable)
 modified: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
 modified: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
 modified: 00000000dfef0000 - 00000000dff00000 (reserved)
 modified: 00000000f0000000 - 00000000f4000000 (reserved)
 modified: 00000000fec00000 - 0000000100000000 (reserved)
 modified: 0000000100000000 - 0000000120000000 (usable)
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-00000000dfee0000
 0000000000 - 00dfe00000 page 2M
 00dfe00000 - 00dfee0000 page 4k
kernel direct mapping tables up to dfee0000 @ 16000-1c000
init_memory_mapping: 0000000100000000-0000000120000000
 0100000000 - 0120000000 page 2M
kernel direct mapping tables up to 120000000 @ 1a000-20000
RAMDISK: 36aea000 - 37fefce7
ACPI: RSDP 00000000000f7da0 00024 (v02 Nvidia)
ACPI: XSDT 00000000dfee3100 0004C (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
ACPI: FACP 00000000dfeeb080 000F4 (v03 Nvidia ASUSACPI 42302E31 AWRD 00000000)
ACPI: DSDT 00000000dfee3280 07DAC (v01 NVIDIA AWRDACPI 00001000 MSFT 03000000)
ACPI: FACS 00000000dfee0000 00040
ACPI: SSDT 00000000dfeeb2c0 0030E (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
ACPI: HPET 00000000dfeeb640 00038 (v01 Nvidia ASUSACPI 42302E31 AWRD 00000098)
ACPI: MCFG 00000000dfeeb6c0 0003C (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
ACPI: APIC 00000000dfeeb1c0 00098 (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-0000000120000000
Bootmem setup node 0 0000000000000000-0000000120000000
  NODE_DATA [000000000001b000 - 000000000002ffff]
  bootmap [0000000000030000 -  0000000000053fff] pages 24
(9 early reservations) ==> bootmem [0000000000 - 0120000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0001000000 - 0001cfa514]    TEXT DATA BSS ==> [0001000000 - 0001cfa514]
  #2 [0036aea000 - 0037fefce7]          RAMDISK ==> [0036aea000 - 0037fefce7]
  #3 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
  #4 [0001cfb000 - 0001cfb15d]              BRK ==> [0001cfb000 - 0001cfb15d]
  #5 [0000010000 - 0000012000]       TRAMPOLINE ==> [0000010000 - 0000012000]
  #6 [0000012000 - 0000016000]      ACPI WAKEUP ==> [0000012000 - 0000016000]
  #7 [0000016000 - 000001a000]          PGTABLE ==> [0000016000 - 000001a000]
  #8 [000001a000 - 000001b000]          PGTABLE ==> [000001a000 - 000001b000]
 [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00120000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x000dfee0
    0: 0x00100000 -> 0x00120000
On node 0 totalpages: 1048175
  DMA zone: 56 pages used for memmap
  DMA zone: 109 pages reserved
  DMA zone: 3818 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 898840 pages, LIFO batch:31
  Normal zone: 1792 pages used for memmap
  Normal zone: 129280 pages, LIFO batch:31
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Detected use of extended apic ids on hypertransport bus
SMP: Allowing 1 CPUs, 0 hotplug CPUs
No local APIC present
APIC: disable apic facility
APIC: switched to apic NOOP
nr_irqs_gsi: 16
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 00000000dfee0000 - 00000000dfee3000
PM: Registered nosave memory: 00000000dfee3000 - 00000000dfef0000
PM: Registered nosave memory: 00000000dfef0000 - 00000000dff00000
PM: Registered nosave memory: 00000000dff00000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000f4000000
PM: Registered nosave memory: 00000000f4000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
Allocating PCI resources starting at dff00000 (gap: dff00000:10100000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:1 nr_node_ids:1
PERCPU: Embedded 29 pages/cpu @ffff880028200000 s87064 r8192 d23528 u2097152
pcpu-alloc: s87064 r8192 d23528 u2097152 alloc=1*2097152
pcpu-alloc: [0] 0 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031938
Policy zone: Normal
Kernel command line: root=/dev/disk/by-id/scsi-SATA_WDC_WD10EAVS-32_WD-WCAU46493538-part1 resume=/dev/disk/by-id/scsi-SATA_WDC_WD10EAVS-32_WD-WCAU46493538-part3 splash=silent vga=0x31a lapic acpi=ht 3
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ 0 size 32 MB
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
PM: Registered nosave memory: 0000000020000000 - 0000000024000000
Memory: 3966568k/4718592k available (3138k kernel code, 525892k absent, 226132k reserved, 5136k data, 1568k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:4352
Extended CMOS year: 2000
spurious 8259A interrupt: IRQ7.
Console: colour dummy device 80x25
console [tty0] enabled
allocated 41943040 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Fast TSC calibration using PIT
Detected 3013.947 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 6027.89 BogoMIPS (lpj=3013947)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
tseg: 00dff00000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
using C1E aware idle routine
Performance Events: 
no APIC, boot with the "lapic" boot parameter to force-enable it.
no hardware sampling interrupt available.
AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
SMP alternatives: switching to UP code
Freeing SMP alternatives: 27k freed
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 14464 entries in 57 pages
Setting APIC routing to noop
weird, boot CPU (#0) not listed by the BIOS.
SMP motherboard not detected.
Apic disabled
Local APIC not detected. Using dummy APIC emulation.
SMP disabled
Brought up 1 CPUs
Total of 1 processors activated (6027.89 BogoMIPS).
devtmpfs: initialized
NET: Registered protocol family 16
node 0 link 0: io port [b000, ffff]
TOM: 00000000e0000000 aka 3584M
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [f4000000, fe02ffff]
node 0 link 0: mmio [f0000000, f03fffff]
TOM2: 0000000120000000 aka 4608M
bus: [00, 03] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [a0000, bffff]
bus: 00 index 2 mmio: [e0000000, f3ffffff]
bus: 00 index 3 mmio: [f4000000, ffffffff]
bus: 00 index 4 mmio: [120000000, fcffffffff]
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Interpreter disabled.
vgaarb: loaded
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:04.0: PME# disabled
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:09.1: reg 20: [io  0x1c00-0x1c3f]
pci 0000:00:09.1: reg 24: [io  0x1c40-0x1c7f]
pci 0000:00:09.1: PME# supported from D3hot D3cold
pci 0000:00:09.1: PME# disabled
pci 0000:00:0a.0: reg 10: [mem 0xfe02f000-0xfe02ffff]
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0a.1: reg 10: [mem 0xfe02e000-0xfe02e0ff]
pci 0000:00:0a.1: supports D1 D2
pci 0000:00:0a.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.1: PME# disabled
pci 0000:00:0c.0: reg 20: [io  0xfd00-0xfd0f]
pci 0000:00:0d.0: reg 10: [io  0x09f0-0x09f7]
pci 0000:00:0d.0: reg 14: [io  0x0bf0-0x0bf3]
pci 0000:00:0d.0: reg 18: [io  0x0970-0x0977]
pci 0000:00:0d.0: reg 1c: [io  0x0b70-0x0b73]
pci 0000:00:0d.0: reg 20: [io  0xf800-0xf80f]
pci 0000:00:0d.0: reg 24: [mem 0xfe02d000-0xfe02dfff]
pci 0000:00:0d.1: reg 10: [io  0x09e0-0x09e7]
pci 0000:00:0d.1: reg 14: [io  0x0be0-0x0be3]
pci 0000:00:0d.1: reg 18: [io  0x0960-0x0967]
pci 0000:00:0d.1: reg 1c: [io  0x0b60-0x0b63]
pci 0000:00:0d.1: reg 20: [io  0xf300-0xf30f]
pci 0000:00:0d.1: reg 24: [mem 0xfe02c000-0xfe02cfff]
pci 0000:00:0d.2: reg 10: [io  0xf200-0xf207]
pci 0000:00:0d.2: reg 14: [io  0xf100-0xf103]
pci 0000:00:0d.2: reg 18: [io  0xf000-0xf007]
pci 0000:00:0d.2: reg 1c: [io  0xef00-0xef03]
pci 0000:00:0d.2: reg 20: [io  0xee00-0xee0f]
pci 0000:00:0d.2: reg 24: [mem 0xfe02b000-0xfe02bfff]
pci 0000:00:0e.1: reg 10: [mem 0xfe024000-0xfe027fff]
pci 0000:00:0e.1: PME# supported from D3hot D3cold
pci 0000:00:0e.1: PME# disabled
pci 0000:00:16.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:16.0: PME# disabled
pci 0000:01:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
pci 0000:01:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
pci 0000:01:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
pci 0000:01:00.0: reg 24: [io  0xdc00-0xdc7f]
pci 0000:01:00.0: reg 30: [mem 0xfbfe0000-0xfbffffff pref]
Marking TSC unstable due to TSC halt in AMD C1E
System has AMD C1E enabled
Switch to broadcast mode on CPU0
pci 0000:00:04.0: PCI bridge to [bus 01-01]
pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:04.0:   bridge window [mem 0xf8000000-0xfbffffff]
pci 0000:00:04.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
pci 0000:02:07.0: reg 10: [io  0xcc00-0xccff]
pci 0000:02:07.0: reg 14: [mem 0xfdfff000-0xfdfff0ff]
pci 0000:02:07.0: reg 30: [mem 0xfdfc0000-0xfdfdffff pref]
pci 0000:02:07.0: supports D1 D2
pci 0000:02:07.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:02:07.0: PME# disabled
pci 0000:02:0b.0: reg 10: [mem 0xfdffe000-0xfdffe7ff]
pci 0000:02:0b.0: reg 14: [mem 0xfdff8000-0xfdffbfff]
pci 0000:02:0b.0: supports D1 D2
pci 0000:02:0b.0: PME# supported from D0 D1 D2 D3hot
pci 0000:02:0b.0: PME# disabled
pci 0000:00:0e.0: PCI bridge to [bus 02-02] (subtractive decode)
pci 0000:00:0e.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:0e.0:   bridge window [mem 0xfdf00000-0xfdffffff]
pci 0000:03:00.0: reg 10: [mem 0xfdeff000-0xfdeff07f 64bit]
pci 0000:03:00.0: reg 18: [mem 0xfdef8000-0xfdefbfff 64bit]
pci 0000:03:00.0: reg 20: [io  0xbc00-0xbc7f]
pci 0000:03:00.0: reg 30: [mem 0xfde00000-0xfde7ffff pref]
pci 0000:03:00.0: supports D1 D2
pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:16.0: PCI bridge to [bus 03-03]
pci 0000:00:16.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:16.0:   bridge window [mem 0xfde00000-0xfdefffff]
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
PCI: Discovered primary peer bus ff [IRQ]
pci 0000:00:00.0: default IRQ router [10de:02f4]
PCI: pci_cache_line_size set to 64 bytes
Switching to clocksource jiffies
pnp: PnP ACPI: disabled
pci 0000:00:04.0: PCI bridge to [bus 01-01]
pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
pci 0000:00:04.0:   bridge window [mem 0xf8000000-0xfbffffff]
pci 0000:00:04.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
pci 0000:00:0e.0: PCI bridge to [bus 02-02]
pci 0000:00:0e.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:0e.0:   bridge window [mem 0xfdf00000-0xfdffffff]
pci 0000:00:0e.0:   bridge window [mem pref disabled]
pci 0000:00:16.0: PCI bridge to [bus 03-03]
pci 0000:00:16.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:16.0:   bridge window [mem 0xfde00000-0xfdefffff]
pci 0000:00:16.0:   bridge window [mem pref disabled]
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci 0000:00:16.0: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:01: resource 1 [mem 0xf8000000-0xfbffffff]
pci_bus 0000:01: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:02: resource 1 [mem 0xfdf00000-0xfdffffff]
pci_bus 0000:02: resource 3 [io  0x0000-0xffff]
pci_bus 0000:02: resource 4 [mem 0x00000000-0xffffffffffffffff]
pci_bus 0000:03: resource 0 [io  0xb000-0xbfff]
pci_bus 0000:03: resource 1 [mem 0xfde00000-0xfdefffff]
pci_bus 0000:ff: resource 0 [io  0x0000-0xffff]
pci_bus 0000:ff: resource 1 [mem 0x00000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Enabling HT MSI Mapping
pci 0000:00:0d.1: Enabling HT MSI Mapping
pci 0000:00:0d.2: Enabling HT MSI Mapping
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:0e.1: Enabling HT MSI Mapping
pci 0000:00:16.0: Enabling HT MSI Mapping
pci 0000:01:00.0: Boot video device
PCI: CLS 32 bytes, default 64
Unpacking initramfs...
Freeing initrd memory: 21527k freed
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
platform rtc_cmos: registered platform RTC device (no PNP device found)
Scanning for low memory corruption every 60 seconds
audit: initializing netlink socket (disabled)
type=2000 audit(1262010348.569:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 7918
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:04.0: setting latency timer to 64
pcieport 0000:00:16.0: setting latency timer to 64
vesafb: framebuffer at 0xf9000000, mapped to 0xffffc90001100000, using 5120k, total 14336k
vesafb: mode is 1280x1024x16, linelength=2560, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 160x64
fb0: VESA VGA frame buffer device
XENFS: not registering filesystem on non-xen platform
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
kgdb: Registered I/O driver kgdbts.
kgdbts:RUN plant and detach test
kgdbts:RUN sw breakpoint test
kgdbts:RUN bad memory access test
kgdbts:RUN singlestep test 1000 iterations
kgdbts:RUN singlestep [0/1000]
kgdbts:RUN singlestep [100/1000]
kgdbts:RUN singlestep [200/1000]
kgdbts:RUN singlestep [300/1000]
kgdbts:RUN singlestep [400/1000]
kgdbts:RUN singlestep [500/1000]
kgdbts:RUN singlestep [600/1000]
kgdbts:RUN singlestep [700/1000]
kgdbts:RUN singlestep [800/1000]
kgdbts:RUN singlestep [900/1000]
kgdbts:RUN hw breakpoint test
kgdbts:RUN hw write breakpoint test
kgdbts:RUN access write breakpoint test
kgdbts:RUN do_fork for 100 breakpoints
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
kmemleak: Kernel memory leak detector initialized
Freeing unused kernel memory: 1568k freed
Write protecting the kernel read-only data: 6144k
Testing CPA: undo ffffffff81000000-ffffffff81600000
Testing CPA: again
kmemleak: Automatic memory scanning thread started
Freeing unused kernel memory: 940k freed
Freeing unused kernel memory: 308k freed
Uniform Multi-Platform E-IDE driver
amd74xx 0000:00:0c.0: UDMA133 controller
amd74xx 0000:00:0c.0: IDE controller (0x10de:0x036e rev 0xa1)
amd74xx 0000:00:0c.0: IDE port disabled
amd74xx 0000:00:0c.0: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xfd00-0xfd07
Probing IDE interface ide0...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
SCSI subsystem initialized
libata version 3.00 loaded.
sata_nv 0000:00:0d.0: version 3.5
sata_nv 0000:00:0d.0: Using SWNCQ mode
sata_nv 0000:00:0d.0: setting latency timer to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xf800 irq 5
ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xf808 irq 5
sata_nv 0000:00:0d.1: Using SWNCQ mode
sata_nv 0000:00:0d.1: setting latency timer to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xf300 irq 5
ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xf308 irq 5
sata_nv 0000:00:0d.2: Using SWNCQ mode
sata_nv 0000:00:0d.2: setting latency timer to 64
scsi4 : sata_nv
scsi5 : sata_nv
ata5: SATA max UDMA/133 cmd 0xf200 ctl 0xf100 bmdma 0xee00 irq 5
ata6: SATA max UDMA/133 cmd 0xf000 ctl 0xef00 bmdma 0xee08 irq 5
ata3: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: WDC WD10EAVS-32D7B1, 01.01A01, max UDMA/133
ata1.00: 1953525168 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD10EAVS-32D 01.0 PQ: 0 ANSI: 5
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: MAXTOR STM3500630AS, 3.AAE, max UDMA/133
ata2.00: 976773168 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      MAXTOR STM350063 3.AA PQ: 0 ANSI: 5
ata4: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
JFS: nTxBlock = 8192, nTxLock = 65536
BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
udev: starting version 149
kgdb: Unregistered I/O driver kgdbts, debugger disabled.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Driver 'rtc_cmos' needs updating - please use bus_type methods
rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 114 bytes nvram
ehci_hcd 0000:00:0a.1: setting latency timer to 64
ehci_hcd 0000:00:0a.1: EHCI Host Controller
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ehci_hcd 0000:00:0a.1: new USB bus registered, assigned bus number 1
 sdb:
 sda:
ehci_hcd 0000:00:0a.1: debug port 1
ehci_hcd 0000:00:0a.1: cache line size of 32 is not supported
ehci_hcd 0000:00:0a.1: irq 5, io mem 0xfe02e000
 sdb1 sdb2 sdb3
 sda1 sda2 sda3
ehci_hcd 0000:00:0a.1: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.33-rc2-next-next-20091228-smp ehci_hcd
usb usb1: SerialNumber: 0000:00:0a.1
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 0:0:0:0: [sda] Attached SCSI disk
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:0a.0: setting latency timer to 64
ohci_hcd 0000:00:0a.0: OHCI Host Controller
ohci_hcd 0000:00:0a.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0a.0: irq 7, io mem 0xfe02f000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.33-rc2-next-next-20091228-smp ohci_hcd
usb usb2: SerialNumber: 0000:00:0a.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
usb 1-4: new high speed USB device using ehci_hcd and address 3
PM: Starting manual resume from disk
XFS mounting filesystem sda1
usb 1-4: New USB device found, idVendor=046d, idProduct=0990
usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=2
usb 1-4: SerialNumber: 7BBC20E7
Ending clean XFS mount for filesystem: sda1
usb 1-9: new high speed USB device using ehci_hcd and address 4
usb 1-9: New USB device found, idVendor=0bda, idProduct=8187
usb 1-9: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-9: Product: RTL8187_Wireless
usb 1-9: Manufacturer: Manufacturer_Realtek_RTL8187_
usb 1-9: SerialNumber: 0015AF230437
usb 2-2: new low speed USB device using ohci_hcd and address 2
usb 2-2: New USB device found, idVendor=046d, idProduct=c404
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: Trackball
usb 2-2: Manufacturer: Logitech
udev: starting version 149
EDAC MC: Ver: 2.1.0 Dec 28 2009
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
i2c i2c-0: nForce2 SMBus adapter at 0x1c00
i2c i2c-1: nForce2 SMBus adapter at 0x1c40
k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
input: PC Speaker as /devices/platform/pcspkr/input/input1
EDAC amd64_edac:  Ver: 3.3.0 Dec 28 2009
EDAC amd64: This node reports that Memory ECC is currently disabled, set F3x44[22] (0000:00:18.3).
EDAC amd64: WARNING: ECC is disabled by BIOS. Module will NOT be loaded.
 Either Enable ECC in the BIOS, or set 'ecc_enable_override'.
 Also, use of the override can cause unknown side effects.
amd64_edac: probe of 0000:00:18.2 failed with error -22
kvm: disabled by bios
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[10]  MMIO=[fdffe000-fdffe7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:02:07.0: no PCI Express capability
eth0: RTL8169sb/8110sb at 0xffffc900010a8000, 00:1c:f0:bb:14:e1, XID 10000000 IRQ 10
usbcore: registered new interface driver hiddev
input: Logitech Trackball as /devices/pci0000:00/0000:00:0a.0/usb2/2-2/2-2:1.0/input/input2
generic-usb 0003:046D:C404.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:0a.0-2/input0
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
cfg80211: Calling CRDA to update world regulatory domain
udev: renamed network interface eth0 to eth_s1_0
Linux video capture interface: v2.00
uvcvideo: Found UVC 1.00 device <unnamed> (046d:0990)
input: UVC Camera (046d:0990) as /devices/pci0000:00/0000:00:0a.1/usb1/1-4/1-4:1.0/input/input3
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
HDA Intel 0000:00:0e.1: setting latency timer to 64
usbcore: registered new interface driver snd-usb-audio
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d800015a4fb7]
phy0: Selected rate control algorithm 'minstrel'
phy0: hwaddr 00:15:af:23:04:37, RTL8187vB (default) V1 + rtl8225z2, rfkill mask 2
rtl8187: Customer ID is 0x00
Registered led device: rtl8187-phy0::radio
Registered led device: rtl8187-phy0::tx
Registered led device: rtl8187-phy0::rx
rtl8187: wireless switch is on
usbcore: registered new interface driver rtl8187
kvm: disabled by bios
i2c /dev entries driver
Adding 11004516k swap on /dev/sda3.  Priority:-1 extents:1 across:11004516k 
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
loop: module loaded
Btrfs loaded
device fsid 8b455ed49c789838-d4076299d5762cad devid 1 transid 928 /dev/sdb1
fuse init (API version 7.13)
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (1 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x2 (1000 MHz), vid 0x12
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    2 : fid 0xc (2000 MHz), vid 0x10
powernow-k8:    3 : fid 0xe (2200 MHz), vid 0x10
powernow-k8:    4 : fid 0x10 (2400 MHz), vid 0xe
powernow-k8:    5 : fid 0x12 (2600 MHz), vid 0xc
powernow-k8:    6 : fid 0x14 (2800 MHz), vid 0xa
powernow-k8:    7 : fid 0x16 (3000 MHz), vid 0x8
r8169: eth_s1_0: link up
CPA self-test:
 4k 2560 large 2043 gb 0 x 2333[ffff880000000000-ffff8800dffff000] miss 131072
 4k 193024 large 1671 gb 0 x 44746[ffff880000000000-ffff8800dffff000] miss 131072
 4k 193024 large 1671 gb 0 x 44746[ffff880000000000-ffff8800dffff000] miss 131072
ok.
it87: Found IT8716F chip at 0x290, revision 0
it87: VID is disabled (pins used for GPIO)
it87: in3 is VCC (+5V)
it87: in7 is VCCH (+5V Stand-By)
NET: Registered protocol family 17
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
wlan0: direct probe to AP 00:1b:9e:82:66:27 (try 1)
wlan0: direct probe to AP 00:1b:9e:82:66:27 (try 1)
wlan0: direct probe responded
wlan0: authenticate with AP 00:1b:9e:82:66:27 (try 1)
wlan0: authenticated
wlan0: associate with AP 00:1b:9e:82:66:27 (try 1)
wlan0: RX AssocResp from 00:1b:9e:82:66:27 (capab=0x411 status=0 aid=4)
wlan0: associated
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
eth_s1_0: no IPv6 routers present
wlan0: no IPv6 routers present

--------------000707040900010400080204--

