Return-Path: <linux-kernel-owner+w=401wt.eu-S1760134AbZANXh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134AbZANXh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 18:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbZANXhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 18:37:19 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:47869 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569AbZANXhS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 18:37:18 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] mmc: Add driver for Freescale eSDHC controllers
Date: Thu, 15 Jan 2009 07:37:00 +0800
Message-ID: <D7CCA83BB0796C49BC0BB53B6AB1208907ABDB@zch01exm21.fsl.freescale.net>
In-Reply-To: <20090114194631.GA25978@oksana.dev.rtsoft.ru>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mmc: Add driver for Freescale eSDHC controllers
Thread-Index: Acl2gXEV/zIvDye2RqSXLN4RM7gGhgAHqpiw
References: <20090114194631.GA25978@oksana.dev.rtsoft.ru>
From: "Liu Dave" <DaveLiu@freescale.com>
To: "Anton Vorontsov" <avorontsov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Cc: <linuxppc-dev@ozlabs.org>, "Lai Kon-LKL001" <Konjin.Lai@freescale.com>,
       <linux-kernel@vger.kernel.org>,
       "Xie Xiaobo-R63061" <X.Xie@freescale.com>,
       "D'Abbraccio Joe-LJD015" <Joe.D'abbraccio@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds support for the Freescale Enhanced Secure Digital
> Host Controller Interface as found in some Freescale PowerPC
> microprocessors (e.g. MPC837x SOCs).

The Freescale ESDHC controller is basically compatible with the
standard SDHC controller. but the eshdc expand some bits.

The esdhc.c is much like the orignal sdhci.c.
it is possible to merge them.

Thanks, Dave
