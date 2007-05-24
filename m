Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbXEXTHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbXEXTHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 15:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbXEXTHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 15:07:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:14299 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbXEXTHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 15:07:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kPDrueLmICQ0FV5ioQyIugZ8ZBwk8VcJ4MxYocrNnm/Dh1IGZ37YHhZ4mcR7kQ8tj3c3WHVmrPLeNCcV5O7xUtsRtlrU8EQe5OUtZOoiCkNACFP/RsC9XyjNAFLgFFogp7QjqgKSsAzS+piS08BjU3L4EPMOVe5U5Ejg326rx3A=
Date: Thu, 24 May 2007 23:06:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: UDF code style conversion to kernel style
Message-ID: <20070524190606.GB20500@cvg>
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

Dunno... Pekka, the patch I sent also added empty lines to separate
some code block to be convenient to read. For some parts of code
additinal 'if...else..' braces were added. Anyway even the code being
formatted by linednt is to be reviewed manually I think. Anyway, your
word Andrew?

		Cyrill

