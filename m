Return-Path: <linux-kernel-owner+w=401wt.eu-S1751718AbZLPFFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbZLPFFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 00:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZLPFFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 00:05:01 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:53929 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbZLPFE7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 00:04:59 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] gianfar: Fix tests of unsigneds in gfar_parse_group()
Date: Wed, 16 Dec 2009 10:34:56 +0530
Message-ID: <9F4C7D19E8361D4C94921B95BE08B81BA08D5A@zin33exm22.fsl.freescale.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] gianfar: Fix tests of unsigneds in gfar_parse_group()
Thread-Index: Acp9tjfZB7rai7bPRBmj1fS0nDtdCQAVjRfQAAAtFDA=
References: <4B27D87D.5070908@gmail.com> 
From: "Kumar Gopalpet-B05799" <B05799@freescale.com>
To: "Roel Kluin" <roel.kluin@gmail.com>, <netdev@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
>Won't it be better to change types of interruptTransmit, 
>-Receive and -Error in  struct gfar_priv_grp itself. Something 
>like this:
>
>struct gfar_priv_grp {
>....
>-	unsigned int interruptTransmit;
>-	unsigned int interruptReceive;
>-	unsigned int interruptError;
>
>+	unsigned int interruptTransmit;
>+	unsigned int interruptReceive;
>+	unsigned int interruptError;
>....
>}
>

Sorry for my earlier mail, What I meant is something like this:

struct gfar_priv_grp {
....
-	unsigned int interruptTransmit;
-	unsigned int interruptReceive;
-	unsigned int interruptError;

+	int interruptTransmit;
+	int interruptReceive;
+	int interruptError;
....
}

--

Thanks
Sandeep
