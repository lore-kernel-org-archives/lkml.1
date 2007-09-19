Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbXISEQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbXISEQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 00:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbXISEPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 00:15:52 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:23233 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbXISEPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 00:15:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=NAd+uKuwOb9DDwrl5rPWiuRKpZzuqZGc79doh/Od0oDk9Q70vT/r45sYfP95nwHIJOJwx6k0ejm90qZYNU6FzCreq3gXb/lII2xPqDtuFf+jiEgURagNNZk3Fcs4x6XD1gZr3fmqwEPXgMiFtKXUfgyYokXzu6qvf2+Bz88a1BA=
Message-ID: <46F0A199.30706@googlemail.com>
Date: Wed, 19 Sep 2007 06:12:09 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [14/17] Allow bit_waitqueue to wait on a bit in a vmalloc area
References: <20070919033605.785839297@sgi.com> <20070919033643.537998421@sgi.com>
In-Reply-To: <20070919033643.537998421@sgi.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:

>  
> +	if (is_vmalloc_addr(word))
> +		page = vmalloc_to_page(word)
					^^^^^^
Missing ' ; '

> +	else
> +		page = virt_to_page(word);
> +
> +	zone = page_zone(page);
>  	return &zone->wait_table[hash_long(val, zone->wait_table_bits)];
>  }
>  EXPORT_SYMBOL(bit_waitqueue);
> 

Regards,

Gabriel
