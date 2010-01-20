Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928Ab0ATD1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab0ATD1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 22:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846Ab0ATD1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 22:27:09 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:39938 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab0ATD1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 22:27:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=LbKaC/11Sch5vjb87cLQmEL1SXO93J5gBe2qVYJwqoGKkm/dQmw/bqlv/eiQRVmTVO
         iTST6jVHpNMYV1BeR5wQD4gSWQEMp9mvMCByaB15LMu9aOBBl6nGSHuqYotjuAv/j21i
         q045C2AvAcOTI5kyLpJkYUBR3ivJjEx93CZo0=
Message-ID: <4B567971.7000904@gmail.com>
Date: Wed, 20 Jan 2010 12:33:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Bart Hartgers <bart.hartgers@gmail.com>
CC: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org
Subject: Re: [patch 1/2] sata_via: Correctly setup PIO/DMA for pata slave
 on vt6421.
References: <20100116235653.898098245@gmail.com> <20100116235849.969478053@gmail.com>
In-Reply-To: <20100116235849.969478053@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2010 08:56 AM, Bart Hartgers wrote:
> Before only the timings for master were set. Datasheet can be found
> here: ftp://ftp.vtbridge.org/Docs/Storage/DS_VT6421A_100_CCPL.PDF
> Surprisingly, a slave drive works without this patch. According to the
> datasheet, the controller by default derives the DMA mode from the 
> Set Features command issued to a drive. Not sure about the PIO
> timings, though. The real problem is that the timings for the master
> effectively are the ones tuned for the slave. If these support
> different UDMA-settings, there is trouble, especially when the slave
> supports a higher UDMA than the master. 
> 
> Anyhow, using the same mechanism for both master and slave seems like 
> a good idea.
> 
> Signed-off-by: Bart Hartgers <bart.hartgers@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
