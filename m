Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbZD1NpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbZD1NpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbZD1NpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:45:04 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:37801 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243AbZD1NpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:45:03 -0400
Message-ID: <49F707FA.7070603@freescale.com>
Date: Tue, 28 Apr 2009 08:43:22 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090327 SeaMonkey/2.0a3
MIME-Version: 1.0
To: David Hawkins <dwh@ovro.caltech.edu>
CC: Liu Dave-R63238 <DaveLiu@freescale.com>, linuxppc-dev@ozlabs.org,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
References: <20090424183517.GB23140@ovro.caltech.edu>	<D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net>	<ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com> <D7CCA83BB0796C49BC0BB53B6AB1208928CAB2@zch01exm21.fsl.freescale.net> <49F65DBA.2090702@ovro.caltech.edu>
In-Reply-To: <49F65DBA.2090702@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Hawkins wrote:
>> How about FIFO RAM case?
> 
> If the FIFO has a fixed address, then according to
> the user guide, the DMA controller won't generate
> a burst transaction to it.
> 
> We can try confirming this if you'd like.

Like I said earlier, this driver does not support copying data to/from a
single register address.  It's just a off-loaded memcpy.  So we don't
need to worry about what happens to a fixed address.

-- 
Timur Tabi
Linux kernel developer at Freescale
