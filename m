Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbYISHk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbYISHk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 03:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYISHkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 03:40:21 -0400
Received: from smtp2e.orange.fr ([80.12.242.112]:44994 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbYISHkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 03:40:21 -0400
X-ME-UUID: 20080919074017937.E4BE2700008E@mwinf2e13.orange.fr
Message-ID: <48D3574B.40209@cosmosbay.com>
Date: Fri, 19 Sep 2008 09:39:55 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, linux-mm@vger.kernel.org,
       jeremy@goop.org, ebiederm@xmission.com, travis@sgi.com,
       herbert@gondor.apana.org.au, xemul@openvz.org
Subject: Re: [patch 4/4] cpu alloc: Use cpu allocator instead of the builtin
 modules per cpu allocator
References: <20080918233648.581696416@quilx.com> <20080918233701.832528677@quilx.com>
In-Reply-To: <20080918233701.832528677@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> Remove the builtin per cpu allocator from modules.c and use cpu_alloc instead.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>

> +		percpu_size = sechdrs[pcpuindex].sh_size;
> +
> +		if (align > PAGE_SIZE) {
> +			printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
> +			      	mod->name, align, PAGE_SIZE);
> +			align = PAGE_SIZE;
> +		}

Minor question : Wy do you have to keep this cap of alignment ?

I could not find such a limit in the allocator




