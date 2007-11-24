Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbXKXCsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbXKXCsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 21:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbXKXCsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 21:48:15 -0500
Received: from rtr.ca ([76.10.145.34]:1240 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbXKXCsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 21:48:14 -0500
Message-ID: <474790EB.90201@rtr.ca>
Date: Fri, 23 Nov 2007 21:48:11 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Robert Hancock <hancockr@shaw.ca>, "Morrison, Tom" <tmorrison@empirix.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v3)
References: <47463534.9010100@shaw.ca> <4746F02D.2060204@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D901053E8542@EMPBEDEX.empirix.com> <474711FE.8040805@rtr.ca> <47476CB9.2040409@shaw.ca> <47476E31.2070801@garzik.org>
In-Reply-To: <47476E31.2070801@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Robert Hancock wrote:
>> Based on a quick look at sata_mv it appears it sets a 64-bit DMA mask 
>> unconditionally, but for non-ATA_PROT_DMA commands (which includes all 
>> ATAPI), it just falls back to ata_qc_issue_prot which issues via the 
>> legacy SFF interface and can only handle 32-bit addressing. So yes, it 
>> appears to have a similar bug as sata_nv had.
> 
> 
> sata_mv doesn't do ATAPI at all...
..

Not yet, anyway.  Stay tuned..
