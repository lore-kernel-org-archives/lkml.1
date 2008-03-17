Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbYCQM12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbYCQM12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 08:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYCQM1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 08:27:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47609 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbYCQM1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 08:27:19 -0400
Message-ID: <47DE63A4.6070709@garzik.org>
Date: Mon, 17 Mar 2008 08:27:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH UPDATED] devres: implement pcim_iomap_regions_request_all()
References: <47D6643A.6060001@gmail.com> <20080311230825.fd631e29.akpm@linux-foundation.org> <47D7779A.3070005@gmail.com>
In-Reply-To: <47D7779A.3070005@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Some drivers need to reserve all PCI BARs to prevent other drivers
> misusing unoccupied BARs.  pcim_iomap_regions_request_all() requests
> all BARs and iomap specified BARs.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Jeff Garzik <jeff@garzik.org>
> ---
> Aieee...  Sorry Andrew.  I forgot doing "quilt add" on the file and
> subsequently missed that pci.h was modified while gitting the repo.
> 
> Here's the corrected version.
> 
>  include/linux/pci.h |    2 ++
>  lib/devres.c        |   25 +++++++++++++++++++++++++
>  2 files changed, 27 insertions(+)

applied


