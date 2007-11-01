Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbXKAJyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbXKAJyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 05:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXKAJyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 05:54:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34436 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbXKAJyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 05:54:08 -0400
Message-ID: <4729A23E.7000601@garzik.org>
Date: Thu, 01 Nov 2007 05:54:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata ATAPI transfer size cleanups
References: <20071101090733.GA9258@havoc.gtf.org> <20071101094344.6eb9d8bc@the-village.bc.nu>
In-Reply-To: <20071101094344.6eb9d8bc@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Thu, 1 Nov 2007 05:07:33 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> This is purely for comment and testing, not for merging (yet?).
>>
>> A common recipe in several vendor drivers (either GPL'd, or I have NDA'd
>> access to use them as a documentation-like reference) for ATAPI was
>> slightly different from ours.  This recipe can be found in
>> atapi_tf_xfer_size(), and it's slightly different from Alan's.
> 
> Looks mostly good. Might cause breakage on one or two controllers by
> setting lbam/lbah to 0 for DMA but we can test that and find out.

DMA always zeroed lbam/lbah thanks to memset(), my patch merely made it 
explicit.


> Note however - the scheme in use now has been tested for over ten years
> in drivers/ide. The scheme below has not...

See my other email just posted, differences and errata abound :)

	Jeff



