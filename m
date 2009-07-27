Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZG0MKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZG0MKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 08:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZG0MKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 08:10:21 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:49648 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbZG0MKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 08:10:19 -0400
Message-ID: <4A6D990B.9000005@csr.com>
Date: Mon, 27 Jul 2009 13:09:47 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Philip Langdale <philipl@overt.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Matt Fleming <matt@console-pimps.org>, ohad@bencohen.org,
       ian@mnementh.co.uk, pierre@ossman.eu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-l@jasper.es
Subject: Re: New MMC maintainer needed
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu>	<20090722151744.fffd7bf5.akpm@linux-foundation.org>	<4A67A9E8.5080002@mnementh.co.uk>	<20090723055447.GA12211@console-pimps.org>	<20090722232259.d0ff3495.akpm@linux-foundation.org>	<20090724152944.51402e87.akpm@linux-foundation.org> <20090726230630.7598fbe4@fido2.homeip.net>
In-Reply-To: <20090726230630.7598fbe4@fido2.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jul 2009 12:09:47.0155 (UTC) FILETIME=[22571E30:01CA0EB3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philip Langdale wrote:
> 
> Both the (Simplified) SD and SDIO specifications do not formally
> define the 'low voltage' range in the way the MMC spec does. ie: You
> won't find anything in the SD specs that even tell you what the range
> is - it just says that it exists.

Standard SD/SDIO cards only support 2.7-3.6V.

1.8V operation is added in SD physical spec 3.00 and is part of any of
the UHS-1 modes (SDR12-SDR104 and DDR50).  It has a different timings
and requires a different (3.00 compliant) host controller.

> So we (I wrote the first incarnation of this check for normal SD
> cards) decided to bail if a card requested the low voltage range.
> Now, if there's actually hardware out there that is SD/SDIO and
> operates at 1.8V, we should probably do something more appropriate.
> :-)

The SD/SDIO stack must ignore reserved bits unless a per-card quirk
gives an additional meaning to the reserved bit.

> It's obviously an easy change but I'd feel a lot more comfortable if 
> someone can point us to a document that states that the SD/SDIO low 
> voltage range is defined to match the MMC one. Maybe one of the NDA 
> docs actually states this.

The non-simplified documents don't say anything on this.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


'member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom'
