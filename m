Return-Path: <linux-kernel-owner+w=401wt.eu-S1760493AbZD0U0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760493AbZD0U0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757318AbZD0U0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:26:45 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:45845 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbZD0U0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:26:44 -0400
Message-ID: <49F614FC.70000@freescale.com>
Date: Mon, 27 Apr 2009 15:26:36 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090327 SeaMonkey/2.0a3
MIME-Version: 1.0
To: David Hawkins <dwh@ovro.caltech.edu>
CC: Liu Dave-R63238 <DaveLiu@freescale.com>, Ira Snyder <iws@ovro.caltech.edu>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
References: <20090424183517.GB23140@ovro.caltech.edu>	<D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net> <ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com> <49F608B7.9080409@ovro.caltech.edu> <49F60A3A.4060402@freescale.com> <49F61416.8040501@ovro.caltech.edu>
In-Reply-To: <49F61416.8040501@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Hawkins wrote:

> PRC_RM - PCI read multiple
>    The default PCI read command used by the DMA controller is
>    PCI Read (PCI command 6h). When the burst length is 32-bytes
>    or longer, PCI Read Line (PCI command Eh) is used (undocumented
>    feature of the controller). Using PCI read multiple
>    (PCI command Ch) results in high-performance across PCI
>    bridges. DMA transfers to non-prefetchable PCI registers
>    should not result in prefetched reads, even when using
>    the PCI read multiple command.

I was thinking more along the lines of:

"This driver tells the DMA controller to use the PCI Read Multiple
command, instead of the PCI Read Line command, for PCI read operations.
 Please be aware that this setting may result in read pre-fetching on
some platforms."

-- 
Timur Tabi
Linux kernel developer at Freescale
