Return-Path: <linux-kernel-owner+w=401wt.eu-S933623AbXBYBvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623AbXBYBvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 20:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933622AbXBYBvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 20:51:31 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58306 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933618AbXBYBva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 20:51:30 -0500
Message-ID: <45E0EB9F.3050001@garzik.org>
Date: Sat, 24 Feb 2007 20:51:27 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Komuro <komurojun-mbn@nifty.com>
Subject: Re: [PATCH] libata: clear drvdata in ata_host_release()
References: <20070224074823.GA20322@htj.dyndns.org>
In-Reply-To: <20070224074823.GA20322@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> ata_host_release() uses drvdata to determine ata_host to release and
> clearing drvdata in ->remove_one causes NULL pointer deference.  Clear
> drvdata only in ata_host_release() after all resources are freed.
> 
> This bug was first analyzed by Alan Cox for pata_pcmcia.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> ---
> Alan, this is the bug you talked about, right?  I took the fix from
> "[BUG] PATA_PCMCIA does not work" and expanded it.  If this isn't the
> one, please let me know.  Thanks.

Has a tester confirmed that this patch fixes the problem, and supercedes 
Alan's patch?

	Jeff


