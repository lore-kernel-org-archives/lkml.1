Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbZB0K00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbZB0K00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbZB0K0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:26:16 -0500
Received: from home.innominate.com ([77.245.32.75]:33681 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbZB0K0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:26:15 -0500
Date: Fri, 27 Feb 2009 11:26:10 +0100
From: Christian Hohnstaedt <chohnstaedt@innominate.com>
To: Karl Hiramoto <karl@hiramoto.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       chohnstaedt@innominate.com, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] ixp4xx_crypto panic with fragmented packets in
	scatterlist
Message-ID: <20090227102609.GD6283@elara.bln.innominate.local>
Mail-Followup-To: Christian Hohnstaedt <chohnstaedt@innominate.com>,
	Karl Hiramoto <karl@hiramoto.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
References: <20090226121043.GA13749@gondor.apana.org.au> <49A6FB1D.2030807@hiramoto.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49A6FB1D.2030807@hiramoto.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 09:27:09PM +0100, Karl Hiramoto wrote:
> Herbert Xu wrote:
>> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>>   
>>> We can't merge this until _all_ of ARM has been fixed for walking
>>> scatterlist chains.
>>>     
>>
>> Right, this is definitely not the way to fix this bug.  Because
>> even if ARM completely supported chaining, you still have to fix
>> all the other architectures as well.
>>
>> So please just fix the driver to remove the chaining before doing
>> DMA.
>>
>>   
> Is there an example of how to do this somewhere? 
>

Not needed.

Now that I know the details about the different ways of chaining
and their scope, I know how to fix my driver properly.

Patch follows, soon...

best regards
Christian

-- 
The iMac is just evidence of how dangerous vi is. Obviously Steve came up with
the name by accident after forgetting he was *already* in insert mode.
 — dagbrown on #emacs
