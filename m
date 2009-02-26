Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbZBZU1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbZBZU1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZBZU1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:27:13 -0500
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:39928 "EHLO
	spunkymail-a17.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752810AbZBZU1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:27:11 -0500
Message-ID: <49A6FB1D.2030807@hiramoto.org>
Date: Thu, 26 Feb 2009 21:27:09 +0100
From: Karl Hiramoto <karl@hiramoto.org>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       chohnstaedt@innominate.com, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] ixp4xx_crypto panic with fragmented packets in	scatterlist
References: <20090226121043.GA13749@gondor.apana.org.au>
In-Reply-To: <20090226121043.GA13749@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 090225-1, 25/02/2009), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>   
>> We can't merge this until _all_ of ARM has been fixed for walking
>> scatterlist chains.
>>     
>
> Right, this is definitely not the way to fix this bug.  Because
> even if ARM completely supported chaining, you still have to fix
> all the other architectures as well.
>
> So please just fix the driver to remove the chaining before doing
> DMA.
>
>   
Is there an example of how to do this somewhere? 

Thanks

Karl
