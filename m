Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbXKXFMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbXKXFMb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 00:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbXKXFMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 00:12:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:12860 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbXKXFMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 00:12:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=N9AwL4bW52UWEWWKhhg5BoHZTSdswyVV7MXRU/hbDzJgWSzbQbWuhYx0QTACT3Khnl8WLB/n09WYSvcXF/ZDs7OacerP5FLJ+1/pMFq+78IUZq4geVmSyRo30t6elYEbAoUqXxxLAoj/+cou61IzWja+Tj+zrV/Q/e1GVvJHAvM=
Message-ID: <4747B2AA.600@gmail.com>
Date: Sat, 24 Nov 2007 14:12:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v3)
References: <47463534.9010100@shaw.ca>
In-Reply-To: <47463534.9010100@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> This fixes some problems with ATAPI devices on nForce4 controllers in ADMA mode
> on systems with memory located above 4GB. We need to delay setting the 64-bit
> DMA mask until the PRD table and padding buffer are allocated so that they don't
> get allocated above 4GB and break legacy mode (which is needed for ATAPI
> devices).
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

Acked-by: Tejun Heo <htejun@gmail.com>

Thanks.

-- 
tejun
