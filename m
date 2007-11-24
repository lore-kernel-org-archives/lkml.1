Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbXKXAU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbXKXAU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 19:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXKXAUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 19:20:12 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44105 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbXKXAUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 19:20:10 -0500
Message-ID: <47476E31.2070801@garzik.org>
Date: Fri, 23 Nov 2007 19:20:01 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Mark Lord <liml@rtr.ca>, "Morrison, Tom" <tmorrison@empirix.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v3)
References: <47463534.9010100@shaw.ca> <4746F02D.2060204@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D901053E8542@EMPBEDEX.empirix.com> <474711FE.8040805@rtr.ca> <47476CB9.2040409@shaw.ca>
In-Reply-To: <47476CB9.2040409@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Based on a quick look at sata_mv it appears it sets a 64-bit DMA mask 
> unconditionally, but for non-ATA_PROT_DMA commands (which includes all 
> ATAPI), it just falls back to ata_qc_issue_prot which issues via the 
> legacy SFF interface and can only handle 32-bit addressing. So yes, it 
> appears to have a similar bug as sata_nv had.


sata_mv doesn't do ATAPI at all...

	Jeff


