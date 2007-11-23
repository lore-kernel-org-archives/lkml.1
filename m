Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbXKWPWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbXKWPWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 10:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbXKWPWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 10:22:24 -0500
Received: from rtr.ca ([76.10.145.34]:1640 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125AbXKWPWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 10:22:23 -0500
Message-ID: <4746F02D.2060204@rtr.ca>
Date: Fri, 23 Nov 2007 10:22:21 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v3)
References: <47463534.9010100@shaw.ca>
In-Reply-To: <47463534.9010100@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> This fixes some problems with ATAPI devices on nForce4 controllers in ADMA mode
> on systems with memory located above 4GB. We need to delay setting the 64-bit
> DMA mask until the PRD table and padding buffer are allocated so that they don't
> get allocated above 4GB and break legacy mode (which is needed for ATAPI
> devices).
...

Mmm.. I wonder how many other libata drivers have this exact same bug,
whether noticed yet or not ?

Cheers
