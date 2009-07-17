Return-Path: <linux-kernel-owner+w=401wt.eu-S934400AbZGQKd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934400AbZGQKd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 06:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934384AbZGQKd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 06:33:27 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:49208 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934364AbZGQKd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 06:33:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xfQkBsFDqTfuBEnMaXDGxHkPp65lqFcOQwxWMtHgY326jIKN0T736RzT6B9C0kXeoV
         DYvzo7xmqoeBLeqz+InSHJq82PGv5WtJfDQzhSSxnedJ0z0VPdvl4qo4ipQ3XPYQ7Pq+
         wxl2Y6mmweRKifOMwiFaoYZOecnTI6/srlhc4=
MIME-Version: 1.0
Date: Fri, 17 Jul 2009 12:33:25 +0200
Message-ID: <35e3b0c00907170333p79c5387bk72f9df453bc0ec83@mail.gmail.com>
Subject: Intended usage of the dmaengine
From: Per Forlin <per.lkml@gmail.com>
To: dan.j.williams@intel.com
Cc: haavard.skinnemoen@atmel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I work with Linux in embedded systems and I got more interested in
dmaengine after Haavard Skinnemoen added the DMA SLAVE support. DMA
SLAVE opens up the dmaengine for embedded users and I wonder if there
is more room for support towards the embedded world. I've made a test
implementation of the dmaengine for our DMAC. Some parts that weren't
supported by the dmaengine had to be exported by the driver code. A
similar example of this is cyclic DMA jobs in dw_dmac.h.
Is this the preferable way to handle it? Or could this functionality
be added to the dmaengine instead?

Additional support that I would like to have in the "struct dma_engine" is
* stopping the dma channel transfer
* continue a stopped transfer
* PER2PER transfers (dma transfer between two peripherals)
* dma transfers from phy mem to per, and per to phy mem
* function to return the transfer count of an active dma transfer
(useful when the dma channel has been stopped deliberately)

I am willing to propose and contribute updates to the dmaengine
regarding this matter. With this email I would like to check with you
whether these types of new support are welcome in the dmaengine.

Thank you for your time and interest,
Per

PS
Dan and Haavard, I apologise for resending this email. I forgot to
send the email as plain text.
