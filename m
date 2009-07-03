Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbZGCJ7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbZGCJ7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZGCJ7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:59:10 -0400
Received: from sdcmail02.amcc.com ([198.137.200.90]:61332 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbZGCJ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:59:09 -0400
X-IronPort-AV: E=Sophos;i="4.42,340,1243839600"; 
   d="txt'?scan'208";a="5973043"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C9FBC4.E54B9C10"
Subject: [PATCH] <bootargs removal from sequoia.dts for PPC > kernel <2.6.30>
Date: Fri, 3 Jul 2009 02:59:01 -0700
Message-ID: <AC311A8E81420D4EBC1F26E6479848FE058A01FF@SDCEXCHANGE01.ad.amcc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] <bootargs removal from sequoia.dts for PPC > kernel <2.6.30>
Thread-Index: Acn7wZyX6171XimhQrem2Yhuq0JlVQAAwmBg
From: "Rupjyoti Sarmah" <rsarmah@amcc.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C9FBC4.E54B9C10
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

4 lines need to be removed from arch/powerpc/boot/dts/sequoia.dts file.=20
Otherwise the nfs fails.=20
The bootargs can be picked up directly from u-boot's bootargs:

----------
=A0
diff -uNr linux-2.6.30/arch/powerpc/boot/dts/sequoia.dts =
linux-2.6.30.1/arch/powerpc/boot/dts/sequoia.dts
--- linux-2.6.30/arch/powerpc/boot/dts/sequoia.dts=A0=A0=A0 2009-06-09 =
20:05:27.000000000 -0700
+++ linux-2.6.30.1/arch/powerpc/boot/dts/sequoia.dts=A0 2009-06-16 =
04:43:54.000000000 -0700
@@ -371,8 +371,5 @@
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 };
=A0=A0=A0=A0=A0 };
=A0
-=A0=A0=A0=A0 chosen {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 linux,stdout-path =3D =
"/plb/opb/serial@ef600300";
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bootargs =3D "console=3DttyS0,115200";
-=A0=A0=A0=A0 };
+=A0=A0=A0=A0=20
=A0};

----------------

------_=_NextPart_001_01C9FBC4.E54B9C10
Content-Type: text/plain;
	name="Readme.txt"
Content-Transfer-Encoding: base64
Content-Description: Readme.txt
Content-Disposition: attachment;
	filename="Readme.txt"

VGhpcyBwYXRjaCBhcHBsaWVzIHRvIHRoZSBhcmNoL3Bvd2VycGMvYm9vdC9kdHMvc2VxdW9pYS5k
dHMgZmlsZSwgc3VibWl0dGVkIGJ5IFJ1cGp5b3RpIFNhcm1haCBmcm9tIEFwcGxpZWQgTWljcm8=

------_=_NextPart_001_01C9FBC4.E54B9C10--
