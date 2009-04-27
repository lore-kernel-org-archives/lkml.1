Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbZD0Ulu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbZD0Ulu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbZD0Ulj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:41:39 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:53683 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbZD0Ulj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:41:39 -0400
Message-ID: <49F6187F.8020703@ovro.caltech.edu>
Date: Mon, 27 Apr 2009 13:41:35 -0700
From: David Hawkins <dwh@ovro.caltech.edu>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Liu Dave-R63238 <DaveLiu@freescale.com>, Ira Snyder <iws@ovro.caltech.edu>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
References: <20090424183517.GB23140@ovro.caltech.edu>	<D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net> <ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com> <49F608B7.9080409@ovro.caltech.edu> <49F60A3A.4060402@freescale.com> <49F61416.8040501@ovro.caltech.edu> <49F614FC.70000@freescale.com>
In-Reply-To: <49F614FC.70000@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 27 Apr 2009 13:41:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Timur,

>> PRC_RM - PCI read multiple
>>    The default PCI read command used by the DMA controller is
>>    PCI Read (PCI command 6h). When the burst length is 32-bytes
>>    or longer, PCI Read Line (PCI command Eh) is used (undocumented
>>    feature of the controller). Using PCI read multiple
>>    (PCI command Ch) results in high-performance across PCI
>>    bridges. DMA transfers to non-prefetchable PCI registers
>>    should not result in prefetched reads, even when using
>>    the PCI read multiple command.
> 
> I was thinking more along the lines of:
> 
> "This driver tells the DMA controller to use the PCI Read Multiple
> command, instead of the PCI Read Line command, for PCI read operations.
>  Please be aware that this setting may result in read pre-fetching on
> some platforms."

Ok, thanks.

Ira will add your comment to the body of the code near
the PRC_RM command and submit a new patch.

Cheers,
Dave

