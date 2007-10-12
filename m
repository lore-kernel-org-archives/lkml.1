Return-Path: <linux-kernel-owner+w=401wt.eu-S932412AbXJLVSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbXJLVSD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbXJLVRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:17:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52265 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361AbXJLVRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:17:49 -0400
Message-ID: <470FE47B.5060505@garzik.org>
Date: Fri, 12 Oct 2007 17:17:47 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Peer Chen <peerchen@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Kuan Luo <kluo@nvidia.com>
Subject: Re: [PATCH] sata_nv,ahci: add the ahci legacy mode support to sata_nv
References: <200709251323031982245@gmail.com>
In-Reply-To: <200709251323031982245@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peer Chen wrote:
> Add the ahci controller legacy mode support to sata_nv.
> Move the DIDs of legacy mode from ahci.c to sata_nv.c
> 
> The patch base on kernel 2.6.23-rc8
> 
> Signed-off-by: Peer Chen <peerchen@gmail.com>

Would you mind checking libata-dev.git#upstream, and make sure it has 
all the NV patches?

I'm thinking I should go ahead and push the 'nv-swncq' branch, which 
contains the sata_nv updates for swncq.  They have been in -mm for a 
while.  I am leaning towards leaving the default to 'off' for 2.6.24 though.

Comments welcome...

	Jeff



