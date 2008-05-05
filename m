Return-Path: <linux-kernel-owner+w=401wt.eu-S1762722AbYEEV40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762722AbYEEV40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbYEEV4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:56:17 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:14978 "EHLO
	outbound9-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368AbYEEV4Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:56:16 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 04/56] microblaze_v2: Open firmware files
Date: Mon, 5 May 2008 14:56:14 -0700
In-reply-to: <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 04/56] microblaze_v2: Open firmware files
Thread-Index: Acit6VsZSMqLRkJGSBykEOhqDGep6QBEUIWQ
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: <monstr@seznam.cz>, <linux-kernel@vger.kernel.org>
Cc: <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
       "John Linn" <linnj@xilinx.com>, <john.williams@petalogix.com>,
       <matthew@wil.cx>, <will.newton@gmail.com>, <drepper@redhat.com>,
       <microblaze-uclinux@itee.uq.edu.au>, <grant.likely@secretlab.ca>,
       "Michal Simek" <monstr@monstr.eu>
X-OriginalArrivalTime: 05 May 2008 21:56:12.0734 (UTC) FILETIME=[D58465E0:01C8AEFA]
Message-Id: <20080505215613.A5B3D18D004F@mail151-sin.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

You're missing some of the stuff implemented in powerpc/prom_parse.c, in
particular this:

Steve

> +/**
> + * of_irq_map_one - Resolve an interrupt for a device
> + * @device:	the device whose interrupt is to be resolved
> + * @index:	index of the interrupt to resolve
> + * @out_irq:	structure of_irq filled by this function
> + *
> + * This function resolves an interrupt, walking the tree, for a given
> + * device-tree node. It's the high level pendant to of_irq_map_raw().
> + * It also implements the workarounds for OldWolrd Macs.
> + */
> +extern int of_irq_map_one(struct device_node *device, int index,
> +			struct of_irq *out_irq);
> +



