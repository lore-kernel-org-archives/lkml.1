Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbXIGXmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbXIGXmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 19:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbXIGXmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 19:42:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:43678 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbXIGXmO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 19:42:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,222,1186383600"; 
   d="scan'208";a="290245577"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.23-rc4][reRESEND] ata_piix: IDE mode SATA patch for Intel Tolapai
Date: Fri, 7 Sep 2007 16:42:12 -0700
Message-ID: <39B20DF628532344BC7A2692CB6AEE0701BCF3BF@orsmsx420.amr.corp.intel.com>
In-Reply-To: <46D7C856.5070901@garzik.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.23-rc4][reRESEND] ata_piix: IDE mode SATA patch for Intel Tolapai
thread-index: Acfro6ZYVismm0zWTY2cxWMowfs1HwGBO/og
References: <200708302136.57215.jason.d.gaston@intel.com> <46D7C856.5070901@garzik.org>
From: "Gaston, Jason D" <jason.d.gaston@intel.com>
To: "Jeff Garzik" <jeff@garzik.org>
Cc: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <htejun@gmail.com>
X-OriginalArrivalTime: 07 Sep 2007 23:42:13.0055 (UTC) FILETIME=[B7029CF0:01C7F1A8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Jeff Garzik [mailto:jeff@garzik.org]
>Sent: Friday, August 31, 2007 12:51 AM
>To: Gaston, Jason D
>Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org;
>htejun@gmail.com
>Subject: Re: [PATCH 2.6.23-rc4][reRESEND] ata_piix: IDE mode SATA patch
for
>Intel Tolapai
>
>Jason Gaston wrote:
>> Resend trying to remove 8-bit characters in the email.
>>
>> This patch adds the Intel Tolapai IDE mode SATA controller DID's.
>>
>> Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
>
>applied

Jeff,

I just noticed that the following section came through as spaces instead
of tabs.  Do I need to resend a corrected version?

+static const struct piix_map_db tolapai_map_db = {
+        .mask = 0x3,
+        .port_enable = 0x3,
+        .map = {
+                /* PM   PS   SM   SS       MAP */
+                {  P0,  NA,  P1,  NA }, /* 00b */
+                {  RV,  RV,  RV,  RV }, /* 01b */
+                {  RV,  RV,  RV,  RV }, /* 10b */
+                {  RV,  RV,  RV,  RV },
+        },
+};
+

Thanks,

Jason
