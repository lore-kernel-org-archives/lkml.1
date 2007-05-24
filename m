Return-Path: <linux-kernel-owner+w=401wt.eu-S1752227AbXEXQ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbXEXQ7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbXEXQ7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:59:04 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59969 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750760AbXEXQ7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:59:02 -0400
Date: Thu, 24 May 2007 09:59:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
cc: Aubrey Li <aubreylee@gmail.com>, Bernhard Walle <bwalle@suse.de>,
       linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: RE: [PATCH] [scsi] Remove __GFP_DMA
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1CAA@otce2k301.adaptec.com>
Message-ID: <Pine.LNX.4.64.0705240958380.28086@schroedinger.engr.sgi.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1CAA@otce2k301.adaptec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Salyzyn, Mark wrote:

> So, is the sequence:
> 
> 	p = kmalloc(upsg->sg[i].count,GFP_KERNEL);
> 	. . .
> 	addr = pci_map_single(dev->pdev, p, upsg->sg[i].count,
> data_dir);
> 
> Going to ensure that we have a 31 bit (not 32 bit) physical address?

Only if you have less than 2G of memory. So no.

