Return-Path: <linux-kernel-owner+w=401wt.eu-S1161159AbXCBBQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161159AbXCBBQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161182AbXCBBQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:16:51 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:46233 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161159AbXCBBQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:16:50 -0500
Message-ID: <45E77AFE.1020605@garzik.org>
Date: Thu, 01 Mar 2007 20:16:46 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Komuro <komurojun-mbn@nifty.com>
Subject: Re: [PATCH] libata: clear drvdata in ata_host_release(), take#2
References: <20070224074823.GA20322@htj.dyndns.org> <45E0EB9F.3050001@garzik.org> <20070227133321.GH20322@htj.dyndns.org>
In-Reply-To: <20070227133321.GH20322@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Clearing drvdata in ->remove_one causes NULL pointer deference.  Clear
> drvdata only in ata_host_release() after all resources are freed.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> pata_pcmcia is fixed by Alan's patch.  This fixes other drivers and
> make libata always clear drvdata after detach.

applied


