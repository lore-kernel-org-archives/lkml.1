Return-Path: <linux-kernel-owner+w=401wt.eu-S933687AbXGZNa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687AbXGZNa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 09:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbXGZNaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 09:30:13 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47557 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbXGZNaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 09:30:11 -0400
Message-ID: <46A8A1E1.3040707@garzik.org>
Date: Thu, 26 Jul 2007 09:30:09 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: Meelis Roos <mroos@linux.ee>, linux-scsi <linux-scsi@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Remove libsas PCI dependencies
References: <Pine.SOC.4.64.0707261129220.17385@math.ut.ee>	 <46A867AB.7050007@garzik.org> <1185454007.3501.34.camel@localhost.localdomain>
In-Reply-To: <1185454007.3501.34.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> Realistically, even for parisc, I can't see anyone producing a non-PCI
> SAS device (even though I'd like one).

A non-PCI device embedded on an SoC or system bus is highly -likely-, IMO.

SAS+SATA silicon (w/out firmware assist as with aic94xx) is the 
direction that Marvell and Broadcom have gone.  I would say it's 
practically inevitable that someone will embed a SAS+SATA chip eventually.


> This should become enum dma_data_direction if we're going to go the
> generic route.

Updated.

	Jeff


