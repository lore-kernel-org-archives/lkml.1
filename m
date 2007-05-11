Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbXEKL43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbXEKL43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 07:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757480AbXEKL4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 07:56:22 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:58099 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbXEKL4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 07:56:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mD3af5Jqx2zb2varInx0cYyKVxXAVCjLLltWbtx3cRfAKIwBOiLozD/agR4j7Iczkmx9HCq62WWvrpw9gleprC+RN+/PXa/KSS6TFmMnSYk6NdpdjJSmI3Y/X4BKL9PGuor4TSkakcDRmknUjjg4Mc4pUiDPe4ccbE+7wAt6jNI=
Message-ID: <464459D8.1030305@gmail.com>
Date: Fri, 11 May 2007 13:56:08 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Tony Breeds <tony@bakeyournoodle.com>
CC: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Akira Iguchi <akira2.iguchi@toshiba.co.jp>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       cbe-oss-dev@ozlabs.org
Subject: Re: [PATCH/RFC] Fix build failure for drivers/ata/pata_scc.c
References: <20070511064954.GE15955@bakeyournoodle.com>
In-Reply-To: <20070511064954.GE15955@bakeyournoodle.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Breeds wrote:
> The commit d4b2bab4f26345ea1803feb23ea92fbe3f6b77bc added deadline support to
> prereset and reset methods to libbata the pata_scc driver wasn't converted.
> This patch is a naive attempt to bring this driver up to scratch.
> 
> Build failures are:
> drivers/ata/pata_scc.c: In function 'scc_pata_prereset':
> drivers/ata/pata_scc.c:870: error: too few arguments to function 'ata_std_prereset'
> drivers/ata/pata_scc.c: In function 'scc_error_handler':
> drivers/ata/pata_scc.c:916: warning: passing argument 2 of 'ata_bmdma_drive_eh' from incompatible pointer type
> drivers/ata/pata_scc.c:916: warning: passing argument 3 of 'ata_bmdma_drive_eh' from incompatible pointer type
> drivers/ata/pata_scc.c: In function 'scc_pata_prereset':
> drivers/ata/pata_scc.c:871: warning: control reaches end of non-void function
> 
> On a releated note scc_bus_post_reset() is (AFACT) identical to
> ata_bus_post_reset(), would a patch to make ata_bus_post_reset() assesable to
> drivers be accepted?
> 
> 
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> CC: Tejun Heo <htejun@gmail.com>
> CC: Akira Iguchi <akira2.iguchi@toshiba.co.jp>
> CC: Jeff Garzik <jgarzik@pobox.com>
> CC: linux-ide@vger.kernel.org

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
