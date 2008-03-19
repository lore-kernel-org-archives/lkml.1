Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbYCSTts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbYCSTts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbYCSTdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:33:03 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:59782 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbYCSTdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:33:00 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH] Fix fsldma.c warning messages when it's compiled underPPC64.
Date: Wed, 19 Mar 2008 09:52:57 +0800
Message-ID: <ABF87B0B6A38C0458E319AC973ED68AED33740@zch01exm26.fsl.freescale.net>
In-Reply-To: <47E00898.2090009@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Fix fsldma.c warning messages when it's compiled underPPC64.
Thread-Index: AciJJSN4nb7NDdKuTuaNMUt6b6P09gAPrLug
References: <1205146045-17342-1-git-send-email-wei.zhang@freescale.com> <20080311142247.GA18915@lixom.net> <ABF87B0B6A38C0458E319AC973ED68AECE526A@zch01exm26.fsl.freescale.net> <e9c3a7c20803120929l41b9fec8m34db73d6e034461a@mail.gmail.com> <ABF87B0B6A38C0458E319AC973ED68AED32DBF@zch01exm26.fsl.freescale.net> <47E00898.2090009@freescale.com>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Wood Scott" <scottwood@freescale.com>
Cc: "Dan Williams" <dan.j.williams@intel.com>,
       "Olof Johansson" <olof@lixom.net>, <sfr@canb.auug.org.au>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m2JKk4nq007452

 

> -----Original Message-----
> From: Wood Scott 
> 
> >>>  The reason is the val will be assigned to SR register, and 
> >> SR register
> >>>   is a 32-bit only register.
> >> If this is the case then why not disable the driver for PPC_64?
> 
> May I point out that SR is a status register, and not an address, and 
> thus it should never have been dma_addr_t to begin with?
> 
Never, thus u32 is good for SR.

Cheers!
Wei.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
