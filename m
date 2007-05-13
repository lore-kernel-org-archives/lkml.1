Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbXEMVBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbXEMVBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 17:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbXEMVBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 17:01:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49108 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbXEMVBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 17:01:34 -0400
Date: Sun, 13 May 2007 22:01:26 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@ucw.cz>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070513210126.GB14030@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Ben Fennema <bfennema@falcon.csc.calpoly.edu>,
	Jan Kara <jack@ucw.cz>
References: <20070510140000.GA12399@cvg> <20070510154640.c0299a52.akpm@linux-foundation.org> <20070511072939.GA25727@infradead.org> <20070511090127.GD9444@cvg> <20070511103956.GA30896@infradead.org> <20070511110920.GA11898@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511110920.GA11898@cvg>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 03:09:20PM +0400, Cyrill Gorcunov wrote:
> | > | And please get rid of the UDF_I_* macro for everything you touch, just
> | > | put a
> | > | 
> | > | 	struct udf_inode_info *uip = UDF_I(inode);
> | > | 
> | > | at the beginning of the function and use the fields directly.
> | > | 
> | > 
> | > Actually to properly remove UDF_I* and UDF_SB_* macroses in the
> | > whole UDF subsystem - is _lot_ of work. I'm going to make it but
> | > not now (too busy).
> | 
> | Doing it completely is a lot of work, yes.  I was more thinking of
> | converting a piece of code once you do major changes.  But if you
> | want to convert all the code as a separate patch I'm more than happy
> | aswell.
> | 
> 
> Christoph, my only argue against getting rid of UDF_I_* macro in
> my patch is UDF coding style, I don't want to damage it. I think
> we may leave it as is (including my patch). So just review the patch
> I sent (second version) and Ack it then so Andrew could include it
> into mm tree. Meantime I'm rewritting the whole UDF subsystem to
> get rid of that macroses (it will be a long way ;)

The UDF style is horrible and very unlike other kernel code.  Given
that udf has been pretty much unmtained for a while there should be
nothing in the way of fixing it.

Anyway, the patch is technically correct so you'll get my ACK (not
that you should need it).

