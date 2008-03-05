Return-Path: <linux-kernel-owner+w=401wt.eu-S1762280AbYCEB76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762280AbYCEB76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbYCEB7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:59:48 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:33040 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYCEB7r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:59:47 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 11/17] Add memory mapping driver to RapidIO.
Date: Wed, 5 Mar 2008 09:59:38 +0800
Message-ID: <ABF87B0B6A38C0458E319AC973ED68AECE4522@zch01exm26.fsl.freescale.net>
In-Reply-To: <20080304213735.c77d6203.sfr@canb.auug.org.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 11/17] Add memory mapping driver to RapidIO.
Thread-Index: Ach948w0Vx50aqjsTlOB6smGRb2osgAgJL4g
References: <1204648202-5495-1-git-send-email-wei.zhang@freescale.com><1204648202-5495-2-git-send-email-wei.zhang@freescale.com><1204648202-5495-3-git-send-email-wei.zhang@freescale.com><1204648202-5495-4-git-send-email-wei.zhang@freescale.com><1204648202-5495-5-git-send-email-wei.zhang@freescale.com><1204648202-5495-6-git-send-email-wei.zhang@freescale.com><1204648202-5495-7-git-send-email-wei.zhang@freescale.com><1204648202-5495-8-git-send-email-wei.zhang@freescale.com><1204648202-5495-9-git-send-email-wei.zhang@freescale.com><1204648202-5495-10-git-send-email-wei.zhang@freescale.com><1204648202-5495-11-git-send-email-wei.zhang@freescale.com> <20080304213735.c77d6203.sfr@canb.auug.org.au>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: <mporter@kernel.crashing.org>, <galak@kernel.crashing.org>,
       <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stephen,

Thanks! I'm considering to commit a updated patch or new code cleaning
patch.
How about your idea?

Cheers!
Wei 

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
> Sent: Tuesday, March 04, 2008 6:38 PM
> To: Zhang Wei
> Cc: mporter@kernel.crashing.org; galak@kernel.crashing.org; 
> linuxppc-dev@ozlabs.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 11/17] Add memory mapping driver to RapidIO.
> 
> On Wed,  5 Mar 2008 00:29:56 +0800 Zhang Wei 
> <wei.zhang@freescale.com> wrote:
> >
> > +	if (!(rmem->virt = dma_alloc_coherent(NULL, rmem->size,
> > +				&rmem->iores.start, GFP_KERNEL))) {
> 
> Please separate assignments from tests.
> 
> > +	if ((ret = rio_space_claim(rmem))) {
> 
> Again.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
> 
