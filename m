Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbXEFTTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbXEFTTc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 15:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbXEFTTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 15:19:32 -0400
Received: from mailgate2.urz.uni-halle.de ([141.48.3.8]:62135 "EHLO
	mailgate2.urz.uni-halle.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755133AbXEFTTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 15:19:31 -0400
Date: Sun, 06 May 2007 21:19:19 +0200
From: Bert Wesarg <wesarg@informatik.uni-halle.de>
Subject: Re: [RFC 1/3] SLUB: slab_ops instead of constructors / destructors
In-reply-to: <20070504221708.363027097@sgi.com>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dgc@sgi.com,
       Eric Dumazet <dada1@cosmosbay.com>, Mel Gorman <mel@csn.ul.ie>
Message-id: <463E2A37.2030400@informatik.uni-halle.de>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.3)
 Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.0
X-Enigmail-Version: 0.95.0
References: <20070504221555.642061626@sgi.com>
 <20070504221708.363027097@sgi.com>
X-Scan-Signature: edee0076758084226236b171d0897308
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

clameter@sgi.com wrote:
> +	if (ctor || dtor) {
> +		so = kzalloc(sizeof(struct slab_ops), GFP_KERNEL);
> +		so->ctor = ctor;
> +		so->dtor = dtor;
> +	}
> +	return  __kmem_cache_create(s, size, align, flags, so);
Is this a memory leak?

Regards
Bert Wesarg
