Return-Path: <linux-kernel-owner+w=401wt.eu-S1762144AbXEPCIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762144AbXEPCIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 22:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757575AbXEPCIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 22:08:05 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:50751 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748AbXEPCIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 22:08:04 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH 2/2] powerpc: Fix Section mismatch warnings
Date: Wed, 16 May 2007 10:09:41 +0800
Message-ID: <989B956029373F45A0B8AF0297081890B760A2@zch01exm26.fsl.freescale.net>
In-Reply-To: <4575ED11-C144-49CF-9FBA-0613B61EFCE3@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] powerpc: Fix Section mismatch warnings
Thread-Index: AceW+nNdGbj2zPYzQB6lnurmQLc3MQAZIyCw
From: "Li Yang-r58472" <LeoLi@freescale.com>
To: "Kumar Gala" <galak@kernel.crashing.org>
Cc: "Paul" <paulus@samba.org>, <linuxppc-dev@ozlabs.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org]
> Sent: Tuesday, May 15, 2007 10:07 PM
> To: Li Yang-r58472
> Cc: Paul; linuxppc-dev@ozlabs.org; Linux Kernel
> Subject: Re: [PATCH 2/2] powerpc: Fix Section mismatch warnings
> 
> 
> On May 14, 2007, at 5:59 AM, Li Yang wrote:
> 
> > This patch fix the following Section mismatch warnings
> > in powerpc code.
> >
> > WARNING: arch/powerpc/platforms/built-in.o - Section mismatch:
> > reference to .init.data:mv643xx_eth_pd_devs from .text between
> > 'mv643xx_eth_add_pds' (at offset 0x9ed2) and 'gg2_read_config'
> > WARNING: arch/powerpc/platforms/built-in.o - Section mismatch:
> > reference to .init.data:mv643xx_eth_pd_devs from .text between
> > 'mv643xx_eth_add_pds' (at offset 0x9ed6) and 'gg2_read_config'
> > WARNING: arch/powerpc/platforms/built-in.o - Section mismatch:
> > reference to .init.text:note_scsi_host from __ksymtab between
> > '__ksymtab_note_scsi_host' (at offset 0x8) and
'__ksymtab_sys_ctrler'
> >
> > Signed-off-by: Li Yang <leoli@freescale.com>
> > ---
> >  arch/powerpc/platforms/chrp/pegasos_eth.c |    2 +-
> >  arch/powerpc/platforms/powermac/setup.c   |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Did you change anything?

Nothing yet. I think it's a delay of mail system.

- Leo
