Return-Path: <linux-kernel-owner+w=401wt.eu-S1760562AbXERA6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562AbXERA6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 20:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbXERA6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 20:58:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43705 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579AbXERA6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 20:58:13 -0400
Message-ID: <464CFA22.1090600@garzik.org>
Date: Thu, 17 May 2007 20:58:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Peer Chen <pchen@nvidia.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] sata_nv: fix fallout of devres conversion
References: <15F501D1A78BD343BE8F4D8DB854566B13CD8F45@hkemmail01.nvidia.com> <464A94D7.30300@garzik.org> <15F501D1A78BD343BE8F4D8DB854566B13DEF520@hkemmail01.nvidia.com> <464C38F5.3060802@gmail.com>
In-Reply-To: <464C38F5.3060802@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> As with all other drivers, sata_nv's hpriv is allocated with
> devm_kzalloc() and there's no need to free it explicitly.  Kill
> nv_remove_one() which incorrectly used kfree() instead of devm_kfree()
> and use ata_pci_remove_one() directly.
> 
> Original fix is from Peer Chen.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Peer Chen <pchen@nvidia.com>
> ---
> 
> I think it's prettier this way.  :-)

applied

you forgot diffstat :)


