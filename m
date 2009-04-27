Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZD0UrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZD0UrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZD0UrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:47:11 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:48944 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZD0UrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:47:10 -0400
Message-ID: <49F619C4.20100@freescale.com>
Date: Mon, 27 Apr 2009 15:47:00 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090327 SeaMonkey/2.0a3
MIME-Version: 1.0
To: Ira Snyder <iws@ovro.caltech.edu>
CC: David Hawkins <dwh@ovro.caltech.edu>,
       Liu Dave-R63238 <DaveLiu@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Dan Williams <dan.j.williams@intel.com>,
       Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
References: <20090424183517.GB23140@ovro.caltech.edu> <D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net> <ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com> <49F608B7.9080409@ovro.caltech.edu> <49F60A3A.4060402@freescale.com> <49F61416.8040501@ovro.caltech.edu> <49F614FC.70000@freescale.com> <20090427204213.GA4960@ovro.caltech.edu>
In-Reply-To: <20090427204213.GA4960@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Kumar to the CC: list, since he might pick up the patch.

Ira Snyder wrote:

> From 73e42fa58c93de8d4d429ba8e069b60c42037b58 Mon Sep 17 00:00:00 2001
> From: Ira W. Snyder <iws@ovro.caltech.edu>
> Date: Thu, 23 Apr 2009 16:17:54 -0700
> Subject: [PATCH] fsldma: use PCI Read Multiple command
> 
> By default, the Freescale 83xx DMA controller uses the PCI Read Line
> command when reading data over the PCI bus. Setting the controller to use
> the PCI Read Multiple command instead allows the controller to read much
> larger bursts of data, which provides a drastic speed increase.
> 
> The slowdown due to using PCI Read Line was only observed when a PCI-to-PCI
> bridge was between the devices trying to communicate.
> 
> A simple test driver showed an increase from 4MB/sec to 116MB/sec when
> performing DMA over the PCI bus. Using DMA to transfer between blocks of
> local SDRAM showed no change in performance with this patch. The dmatest
> driver was also used to verify the correctness of the transfers, and showed
> no errors.
> 
> Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>

Acked-by: Timur Tabi <timur@freescale.com>

-- 
Timur Tabi
Linux kernel developer at Freescale
