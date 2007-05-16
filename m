Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbXEPITS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbXEPITS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbXEPITH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:19:07 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:1434 "EHLO
	outbound1-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753066AbXEPITF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:19:05 -0400
X-BigFish: V
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-7"
Content-Transfer-Encoding: 7bit
Subject: =?utf-7?B?UkU6ICtBRnMtUEFUQ0ggNC80K0FGMC0gQWRkIHRoZSBjb21iaW5lZA==?=
	=?utf-7?B?IG1vZGUgZm9yIEFUSSBTQjcwMA==?=
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Wed, 16 May 2007 16:13:51 +0800
Message-ID: <FFECF24D2A7F6D418B9511AF6F35860201A9F099@shacnexch2.atitech.com>
In-Reply-To: <464AB979.2020107@garzik.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: =?utf-7?B?K0FGcy1QQVRDSCA0LzQrQUYwLSBBZGQgdGhlIGNvbWJpbmVkIG1vZA==?=
	=?utf-7?B?ZSBmb3IgQVRJIFNCNzAw?=
Thread-Index: AceXj/Z53k/XXOKcRR
From: "Henry Su" <henry.su@amd.com>
To: "Jeff Garzik" <jeff@garzik.org>
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>,
       =?utf-7?B?Z21haWwrQUY4LWF0aQ==?= <henry.su.ati@gmail.com>
X-OriginalArrivalTime: 16 May 2007 08:13:55.0157 (UTC) FILETIME=[25625850:01C79792]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi Jeff,
this patch is used to set the SATA controller back to AHCI mode when ATI SB700 is set 
as combined mode or legacy IDE mode by BIOS, without this patch, just like ATI SB600, 
the SB700 SATA device will fail in these two modes.

BRs,
henry 

-----Original Message-----
From: Jeff Garzik +AFs-mailto:jeff+AEA-garzik.org+AF0- 
Sent: Wednesday, May 16, 2007 3:58 PM
To: Henry Su
Cc: Bartlomiej Zolnierkiewicz+ADs- gregkh+AEA-suse.de+ADs- linux-kernel+AEA-vger.kernel.org+ADs- gmail+AF8-ati
Subject: Re: +AFs-PATCH 4/4+AF0- Add the combined mode for ATI SB700

Henry Su wrote:
+AD4- From: henry.su+AEA-amd.com
+AD4- Besides those modes in ATI SB600 SATA controller, ATI SB700 supports one more mode:the combined mode.
+AD4- 
+AD4- The combined mode is a Legacy IDE mode used for compatibility with some old OS without AHCI driver, 
+AD4- but now it is not necessary for Linux since the kernel has supported AHCI.

hmmmm.  The patch looks OK, but your description seems to indicate that
the patch is not needed?

	Jeff






