Return-Path: <linux-kernel-owner+w=401wt.eu-S1760472AbXEKLKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760472AbXEKLKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 07:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbXEKLKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 07:10:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:13175 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770AbXEKLKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 07:10:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=q40Ic0+MkYHgaEek537OBPl4OxgxI6fFqLHHLPb96XZy9YW6crPiF2uZ6XQbPFwN9DlztgG+wutdZ3DpcdGeyFi1WH97CxIgWy/3l8Qd0kTtTZ44U4slgEODL+otrNnSknkDZHhQM1C385wR+JqKCRgMEnRKUyFrrrcU64IyCxI=
Date: Fri, 11 May 2007 15:09:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@ucw.cz>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070511110920.GA11898@cvg>
References: <20070510140000.GA12399@cvg> <20070510154640.c0299a52.akpm@linux-foundation.org> <20070511072939.GA25727@infradead.org> <20070511090127.GD9444@cvg> <20070511103956.GA30896@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511103956.GA30896@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Hellwig - Fri, May 11, 2007 at 11:39:56AM +0100]
| On Fri, May 11, 2007 at 01:01:27PM +0400, Cyrill Gorcunov wrote:
| > [Christoph Hellwig - Fri, May 11, 2007 at 08:29:39AM +0100]
| > 
| > ...
| > 
| > | And please get rid of the UDF_I_* macro for everything you touch, just
| > | put a
| > | 
| > | 	struct udf_inode_info *uip = UDF_I(inode);
| > | 
| > | at the beginning of the function and use the fields directly.
| > | 
| > 
| > Actually to properly remove UDF_I* and UDF_SB_* macroses in the
| > whole UDF subsystem - is _lot_ of work. I'm going to make it but
| > not now (too busy).
| 
| Doing it completely is a lot of work, yes.  I was more thinking of
| converting a piece of code once you do major changes.  But if you
| want to convert all the code as a separate patch I'm more than happy
| aswell.
| 

Christoph, my only argue against getting rid of UDF_I_* macro in
my patch is UDF coding style, I don't want to damage it. I think
we may leave it as is (including my patch). So just review the patch
I sent (second version) and Ack it then so Andrew could include it
into mm tree. Meantime I'm rewritting the whole UDF subsystem to
get rid of that macroses (it will be a long way ;)

		Cyrill

P.S.
But if you still insist on getting rid of UDF_I_ macroses from my patch
just let me now :)

