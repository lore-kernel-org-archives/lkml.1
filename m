Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbXEPOlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbXEPOlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 10:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbXEPOlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 10:41:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:16196 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbXEPOlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 10:41:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bOm1+BdteOs7g3liWT0jYoeEsFP/WC7xeidDhgHa2QabLlOUe5Xm3vQJcG2SLHd2/CvaeIs5dCAXtyXlRGkkAklqcOjjvh7X52jt2fusNaP7sfrYRws3HzSvrReYYzxJh5zREa1WVGOnj/hAgXTuieGhm2Xc8NH1/nFyNawit0k=
Date: Wed, 16 May 2007 18:33:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Hellwig <hch@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@ucw.cz>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070516143308.GA8327@cvg>
References: <20070510140000.GA12399@cvg> <20070510154640.c0299a52.akpm@linux-foundation.org> <20070511072939.GA25727@infradead.org> <20070511090127.GD9444@cvg> <20070511103956.GA30896@infradead.org> <20070511110920.GA11898@cvg> <20070513210126.GB14030@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070513210126.GB14030@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Hellwig - Sun, May 13, 2007 at 10:01:26PM +0100]
| On Fri, May 11, 2007 at 03:09:20PM +0400, Cyrill Gorcunov wrote:
| > | > | And please get rid of the UDF_I_* macro for everything you touch, just
| > | > | put a
| > | > | 
| > | > | 	struct udf_inode_info *uip = UDF_I(inode);
| > | > | 
| > | > | at the beginning of the function and use the fields directly.
| > | > | 
| > | > 
| > | > Actually to properly remove UDF_I* and UDF_SB_* macroses in the
| > | > whole UDF subsystem - is _lot_ of work. I'm going to make it but
| > | > not now (too busy).
| > | 
| > | Doing it completely is a lot of work, yes.  I was more thinking of
| > | converting a piece of code once you do major changes.  But if you
| > | want to convert all the code as a separate patch I'm more than happy
| > | aswell.
| > | 
| > 
| > Christoph, my only argue against getting rid of UDF_I_* macro in
| > my patch is UDF coding style, I don't want to damage it. I think
| > we may leave it as is (including my patch). So just review the patch
| > I sent (second version) and Ack it then so Andrew could include it
| > into mm tree. Meantime I'm rewritting the whole UDF subsystem to
| > get rid of that macroses (it will be a long way ;)
| 
| The UDF style is horrible and very unlike other kernel code.  Given
| that udf has been pretty much unmtained for a while there should be
| nothing in the way of fixing it.
| 
| Anyway, the patch is technically correct so you'll get my ACK (not
| that you should need it).
| 

Hi Christoph,

you know I've read UDF sources. As I understand all UDF_I_ macroses
could be converted without breaking UDF state but... as you exactly
mentoined it's style is horrible and I'm thinking about rewritting the
whole UDF system. Unfortunelly I'm not _mature_ kernel developer (I'm kernel
newbie) and it could take a long time for this (I think something like
~ 3 month or more ;). Actually I'm ready to spend my free time for
this. So how do you think could it be reasonable?

		Cyrill

