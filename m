Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYGOKyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYGOKyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 06:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbYGOKxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 06:53:51 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:1238 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbYGOKxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 06:53:50 -0400
Date: Tue, 15 Jul 2008 13:52:53 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Chandru <chandru@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables
	in kdump
Message-ID: <20080715105253.GB7245@il.ibm.com>
References: <1191962414.24134.68.camel@chandru> <200806211741.43703.chandru@in.ibm.com> <20080623192918.GB6989@il.ibm.com> <200807151415.27845.chandru@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807151415.27845.chandru@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 02:15:27PM +0530, Chandru wrote:
> kdump kernel fails to boot with calgary iommu and aacraid driver on a x366 
> box. The ongoing dma's of aacraid from the first kernel continue to exist 
> until the driver is loaded in the kdump kernel. Calgary is initialized prior 
> to aacraid and creation of new tce tables causes wrong dma's to occur. Here 
> we try to get the tce tables of the first kernel in kdump kernel and use 
> them. While in the kdump kernel we do not allocate new tce tables but instead 
> read the base addres register contents of calgary iommu and use the tables 
> that the registers point to. With these changes the kdump kernel and hence 
> aacraid now boots normally.
> 
> Signed-off-by: Chandru Siddalingappa <chandru@in.ibm.com>

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Cheers,
Muli
