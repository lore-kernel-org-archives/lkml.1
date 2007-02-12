Return-Path: <linux-kernel-owner+w=401wt.eu-S965266AbXBLUJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965266AbXBLUJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965268AbXBLUJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:09:54 -0500
Received: from nz-out-0506.google.com ([64.233.162.234]:33606 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965266AbXBLUJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:09:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Ye7R6OlfkZ7vz0j72kTD68V4PqAEDuX5430Leq/Co1OZ4n6VmdsKRfhwE5mytklrsnbSeDwKFVvDmRbBBQ8reTryqCXs6ISlGKIva/BzPcciDzoxhVa9Da5vQmXYMXbcu2Hq006gmiXK7XtnskWNc/DtZhUBLMTI9QcclKA+iJ8=
Message-ID: <45D0C97C.108@gmail.com>
Date: Mon, 12 Feb 2007 12:09:32 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Matthew Fredrickson <creslin@digium.com>
CC: linux-kernel@vger.kernel.org, ris <ris@elsat.net.pl>
Subject: Re: High CPU usage with sata_nv
References: <20070115164541.M22367@elsat.net.pl> <20070115165432.M87238@elsat.net.pl> <20070115182642.GA18374@slug> <20070115222320.M55059@elsat.net.pl> <45B43241.1070301@gmail.com> <loom.20070211T232847-590@post.gmane.org> <45D00DF7.6090605@gmail.com> <9d377bf8f83da4ca7935f5a69cde5bef@digium.com>
In-Reply-To: <9d377bf8f83da4ca7935f5a69cde5bef@digium.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Fredrickson wrote:
> I have noticed something that might be related as well.  I am working on 
> a device driver that would have periodic data errors due to 
> exceptionally long interrupt handling latency.  I have come to the point 
> that I suspect that it's the sata_nv driver, and now that we can't do 
> the hdparm -u1 option for sata, it seems to be a bigger problem.

That's mostly off topic.  libata configures DMA if at all possible and 
fallback to PIO only after a lot of serious errors.  Is your drive in 
pio mode?  Or does it happen even when in dma mode?

-- 
tejun
