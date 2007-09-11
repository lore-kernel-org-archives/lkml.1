Return-Path: <linux-kernel-owner+w=401wt.eu-S1763469AbXIKKLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763469AbXIKKLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 06:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965829AbXIKKLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 06:11:04 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:46986 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965688AbXIKKLB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 06:11:01 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx processors.
Date: Tue, 11 Sep 2007 18:10:53 +0800
Message-ID: <46B96294322F7D458F9648B60E15112C85D61E@zch01exm26.fsl.freescale.net>
In-Reply-To: <BAE9DCEF64577A439B3A37F36F9B691C02FF08A1@orsmsx418.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx processors.
Thread-Index: AcfxPC/wGi09hKt4R6O5xlS4AldUsgAJWZkgAL6GIGA=
References: <11891624582950-git-send-email-wei.zhang@freescale.com> <BAE9DCEF64577A439B3A37F36F9B691C02FF08A1@orsmsx418.amr.corp.intel.com>
From: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
To: "Nelson, Shannon" <shannon.nelson@intel.com>, <paulus@samba.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       <galak@kernel.crashing.org>,
       "Zhu Ebony-r57400" <ebony.zhu@freescale.com>,
       <dan.j.williams@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> If this is experimental, perhaps you should mark the depends line as
> such
> 	depends on on DMA_ENGINE && PPC && EXPERIMENTAL

I'll add EXPERIMENTAL for MPC83xx only.

> 
> [...]
> 
> >+
> >+	fsl_dma_memcpy_issue_pending(chan);
> >+	while (fsl_dma_is_complete(chan, cookie, NULL, NULL)
> >+			!= DMA_SUCCESS);
> 
> Again, is it possible to hang your thread here?
> 
> [...]

I'll add msleep here.

Thanks!

- zw
