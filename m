Return-Path: <linux-kernel-owner+w=401wt.eu-S1751367AbXEXSru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbXEXSru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbXEXSrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:47:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:20703 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbXEXSrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:47:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LRYjA4YDXu/540QgSrZ3s978GSQtwt491dT0XRAq9mrHVXVXJzr0GL7VhWRHUC0lSSZ8+RbtGSrJtq23kP/yGGOw+WQaE4SwmdLqhoYescZh2M9xC/VJdrcOW1Xnyx/bNYo0UBC1rY0rpLoktY0fy+evaWpY+eEpwYg/FYNEysc=
Message-ID: <84144f020705241147j5e2fa91bg229db86a63a9efb5@mail.gmail.com>
Date: Thu, 24 May 2007 21:47:42 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH]: UDF code style conversion to kernel style
Cc: "Jan Kara" <jack@suse.cz>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Ben Fennema" <bfennema@falcon.csc.calpoly.edu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070523184436.GA14771@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070523184436.GA14771@cvg>
X-Google-Sender-Auth: 66a67c1584a5069f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

On 5/23/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> @@ -2103,7 +1944,7 @@ long udf_block_map(struct inode *inode, sector_t block)
>  	kernel_lb_addr eloc;
>  	uint32_t elen;
>  	sector_t offset;
> -	struct extent_position epos = { NULL, 0, { 0, 0}};
> +	struct extent_position epos = {};

Bits like these in the middle of indentation fixes makes me feel
uneasy. Could we simply ask Andrew to run Lindent on the UDF sources
at some convinient point and push those to Linus like we did with
mm/slab.c if I recall correctly? Its safer to do cleanups like these
after that.
