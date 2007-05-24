Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbXEXTJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbXEXTJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 15:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXEXTJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 15:09:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:16967 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbXEXTJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 15:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=dtApGtq6Z7TTYMwy5Zfto//GE75gtUTlqcUbVtqChhbJe/i3t2TX6q/qX1E+ggxGsS2gw5fSk6qc5N+Et+pWYx//PUBQsFaf1dMo5PKyMCLUvKJvYcyYHTOZ30hOmcLz1sc/vPgZJPBEM4R09kWoxZKGQrf3M8fq9PkuvQ71BXc=
Date: Thu, 24 May 2007 23:08:26 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: UDF code style conversion to kernel style
Message-ID: <20070524190826.GC20500@cvg>
References: <20070523184436.GA14771@cvg> <84144f020705241147j5e2fa91bg229db86a63a9efb5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020705241147j5e2fa91bg229db86a63a9efb5@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Thu, May 24, 2007 at 09:47:42PM +0300]
| Hi Cyrill,
| 
| On 5/23/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| >@@ -2103,7 +1944,7 @@ long udf_block_map(struct inode *inode, sector_t 
| >block)
| > 	kernel_lb_addr eloc;
| > 	uint32_t elen;
| > 	sector_t offset;
| >-	struct extent_position epos = { NULL, 0, { 0, 0}};
| >+	struct extent_position epos = {};
| 
| Bits like these in the middle of indentation fixes makes me feel
| uneasy. Could we simply ask Andrew to run Lindent on the UDF sources
| at some convinient point and push those to Linus like we did with
| mm/slab.c if I recall correctly? Its safer to do cleanups like these
| after that.
| 

And Pekka the patch I sent will be remaked anyway after some fixes. So
if you don't like the conversion you pointed - just let me know and
I'll not do that ;)

		Cyrill

