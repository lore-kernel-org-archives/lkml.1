Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbZD0UFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbZD0UFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbZD0UE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:04:57 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:41159 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201AbZD0UE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:04:57 -0400
Message-ID: <49F60FE1.90707@freescale.com>
Date: Mon, 27 Apr 2009 15:04:49 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090327 SeaMonkey/2.0a3
MIME-Version: 1.0
To: David Hawkins <dwh@ovro.caltech.edu>
CC: linuxppc-dev@ozlabs.org, Dan Williams <dan.j.williams@intel.com>,
       Liu Dave-R63238 <DaveLiu@freescale.com>, linux-kernel@vger.kernel.org,
       Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
References: <20090424183517.GB23140@ovro.caltech.edu>	<D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net>	<ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com>	<49F608B7.9080409@ovro.caltech.edu> <49F60A3A.4060402@freescale.com> <49F60BF8.8040404@ovro.caltech.edu>
In-Reply-To: <49F60BF8.8040404@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Hawkins wrote:

> Can you give me an example of non-PCI memory that would be
> non-prefetchable that you'd like us to try? We can see if our
> host CPUs have an area like that ... we just need to know
> what device to look for first :)

Hmmmm.... I was going to say any SOC device in the IMMR, but I don't see
anything there that would constitute a memory buffer.

I test this change on an 8610 and DMA to a register I/O, where this bit
isn't even defined, and it made no difference.  So I guess this change
is okay.

Acked-by: Timur Tabi <timur@freescale.com>

-- 
Timur Tabi
Linux kernel developer at Freescale
