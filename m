Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYBRHYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYBRHYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYBRHYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:24:37 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:34354 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbYBRHYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:24:36 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/6] Add OF-tree support to RapidIO controller driver.
Date: Mon, 18 Feb 2008 15:24:30 +0800
Message-ID: <ABF87B0B6A38C0458E319AC973ED68AEC3DEF3@zch01exm26.fsl.freescale.net>
In-Reply-To: <4A9328DB-F68C-4C09-B762-44FEA85DD12E@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/6] Add OF-tree support to RapidIO controller driver.
Thread-Index: AchoERbs1v3Yj8OsSOO+eGtlhY5ClQJ7hzFg
References: <1201689053956-git-send-email-wei.zhang@freescale.com> <12016890621727-git-send-email-wei.zhang@freescale.com> <120168907160-git-send-email-wei.zhang@freescale.com> <12016890773706-git-send-email-wei.zhang@freescale.com> <12016890832943-git-send-email-wei.zhang@freescale.com> <20080205164425.b6af5bff.sfr@canb.auug.org.au> <4A9328DB-F68C-4C09-B762-44FEA85DD12E@kernel.crashing.org>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Kumar Gala" <galak@kernel.crashing.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: <mporter@kernel.crashing.org>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org] 
> 
> 
> On Feb 4, 2008, at 11:44 PM, Stephen Rothwell wrote:
> 
> >>
> >> +	aw = *(u32 *)of_get_property(dev->node, "#address-cells", NULL);
> >> +	sw = *(u32 *)of_get_property(dev->node, "#size-cells", NULL);
> >
> > What happens if either of these properties is missing?
> 
> Should we add __must_check to of_get_property?
> 

You are right, I'll add the checking here.

Thanks!
Wei.
