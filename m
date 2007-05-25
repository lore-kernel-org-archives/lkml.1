Return-Path: <linux-kernel-owner+w=401wt.eu-S1761309AbXEYLAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309AbXEYLAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbXEYLAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:00:22 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:11324 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbXEYLAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:00:20 -0400
X-BigFish: V
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 209.50.91.134;Service: EHS
Subject: =?utf-7?B?UkU6ICtBRnMtcGF0Y2grQUYwLSBBZGQgdGhlIGRldmljZSBJRHMgZg==?=
	=?utf-7?B?b3IgQU1EL0FUSSBTQjcwMA==?=
Date: Fri, 25 May 2007 19:00:05 +0800
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C79EBB.DA236DD5"
Message-ID: <FFECF24D2A7F6D418B9511AF6F35860201B3658E@shacnexch2.atitech.com>
In-Reply-To: <46568C7C.70608@garzik.org>
Content-class: urn:content-classes:message
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: =?utf-7?B?K0FGcy1wYXRjaCtBRjAtIEFkZCB0aGUgZGV2aWNlIElEcyBmb3IgQQ==?=
	=?utf-7?B?TUQvQVRJIFNCNzAw?=
Thread-Index: AceenDTRyu1bwISfQ7+pI5E92vlhtQAE+KMg
From: "Henry Su" <henry.su@amd.com>
To: "Jeff Garzik" <jeff@garzik.org>
Cc: <alan@lxorguk.ukuu.org.uk>, <greg@kroah.com>, <bzolnier@gmail.com>,
       <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       <xiaosuzi520@hotmail.com>
X-OriginalArrivalTime: 25 May 2007 11:00:10.0292 (UTC) FILETIME=[DCBEE740:01C79EBB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C79EBB.DA236DD5
Content-Type: text/plain;
	charset="utf-7"
Content-Transfer-Encoding: 7bit

Hi Jeff,
I check the latest kernel source code with git, and find out that the SMBus patch has not been applied yet, 
and the patch for IDE  has not been  applied completely.one more device id should be added to pata+AF8-atiixp.c,
l list the patch as following, or you can fetch it from the attached file, could you please apply this for me? 

Thank you very much+ACE-

Henry


diff -Nur linux-2.6.21.1.orig/drivers/ata/pata+AF8-atiixp.c linux-2.6.21.1/drivers/ata/pata+AF8-atiixp.c
--- linux-2.6.21.1.orig/drivers/ata/pata+AF8-atiixp.c       2007-05-16 13:27:49.764761000 +-0800
+-+-+- linux-2.6.21.1/drivers/ata/pata+AF8-atiixp.c    2007-05-16 13:37:47.014761000 +-0800
+AEAAQA- -283,6 +-283,7 +AEAAQA-
        +AHs- PCI+AF8-VDEVICE(ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP300+AF8-IDE), +AH0-,
        +AHs- PCI+AF8-VDEVICE(ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP400+AF8-IDE), +AH0-,
        +AHs- PCI+AF8-VDEVICE(ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP600+AF8-IDE), +AH0-,
+-       +AHs- PCI+AF8-VDEVICE(ATI, PCI+AF8-DEVICE+AF8-ID+AF8-ATI+AF8-IXP700+AF8-IDE), +AH0-,

        +AHs- +AH0-,
 +AH0AOw-




-----Original Message-----
From: Jeff Garzik +AFs-mailto:jeff+AEA-garzik.org+AF0- 
Sent: Friday, May 25, 2007 3:13 PM
To: Henry Su
Cc: alan+AEA-lxorguk.ukuu.org.uk+ADs- greg+AEA-kroah.com+ADs- bzolnier+AEA-gmail.com+ADs- linux-kernel+AEA-vger.kernel.org+ADs- linux-ide+AEA-vger.kernel.org+ADs- xiaosuzi520+AEA-hotmail.com
Subject: Re: +AFs-patch+AF0- Add the device IDs for AMD/ATI SB700

Henry Su wrote:
+AD4-  Hi Jeff,
+AD4- Thanks for your kindly help, I will fix the email next time.
+AD4- Do you mean all the device IDs for ATI SB700 are added to the corresponding files?
+AD4- because I split this patch and resent four patches according to your last suggestion,
+AD4- if this patch is applied, another patches are  not necessary now.

Splitting up the patches helped us all.  The AHCI, drivers/ide, and now
pata+AF8-atiixp patches were applied by the respective maintainers.  Let me
know if you need a quick introduction to git, which is the main tool to
watch the latest Linux kernel source code (it's like CVS, but better :))

I don't know about the SMBus patch, though.  That may or may not have
been applied.

	Jeff






------_=_NextPart_001_01C79EBB.DA236DD5
Content-Type: application/octet-stream;
	name="IDE.patch"
Content-Transfer-Encoding: base64
Content-Description: IDE.patch
Content-Disposition: attachment;
	filename="IDE.patch"

ZGlmZiAtTnVyIGxpbnV4LTIuNi4yMS4xLm9yaWcvZHJpdmVycy9hdGEvcGF0YV9hdGlpeHAuYyBs
aW51eC0yLjYuMjEuMS9kcml2ZXJzL2F0YS9wYXRhX2F0aWl4cC5jCi0tLSBsaW51eC0yLjYuMjEu
MS5vcmlnL2RyaXZlcnMvYXRhL3BhdGFfYXRpaXhwLmMJMjAwNy0wNS0xNiAxMzoyNzo0OS43NjQ3
NjEwMDAgKzA4MDAKKysrIGxpbnV4LTIuNi4yMS4xL2RyaXZlcnMvYXRhL3BhdGFfYXRpaXhwLmMJ
MjAwNy0wNS0xNiAxMzozNzo0Ny4wMTQ3NjEwMDAgKzA4MDAKQEAgLTI4Myw2ICsyODMsNyBAQAog
CXsgUENJX1ZERVZJQ0UoQVRJLCBQQ0lfREVWSUNFX0lEX0FUSV9JWFAzMDBfSURFKSwgfSwKIAl7
IFBDSV9WREVWSUNFKEFUSSwgUENJX0RFVklDRV9JRF9BVElfSVhQNDAwX0lERSksIH0sCiAJeyBQ
Q0lfVkRFVklDRShBVEksIFBDSV9ERVZJQ0VfSURfQVRJX0lYUDYwMF9JREUpLCB9LAorCXsgUENJ
X1ZERVZJQ0UoQVRJLCBQQ0lfREVWSUNFX0lEX0FUSV9JWFA3MDBfSURFKSwgfSwKIAogCXsgfSwK
IH07CgoK

------_=_NextPart_001_01C79EBB.DA236DD5--

