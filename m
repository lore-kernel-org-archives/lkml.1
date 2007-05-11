Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbXEKKkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbXEKKkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 06:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbXEKKkC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 06:40:02 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56233 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbXEKKkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 06:40:00 -0400
Date: Fri, 11 May 2007 11:39:56 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@ucw.cz>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070511103956.GA30896@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Ben Fennema <bfennema@falcon.csc.calpoly.edu>,
	Jan Kara <jack@ucw.cz>
References: <20070510140000.GA12399@cvg> <20070510154640.c0299a52.akpm@linux-foundation.org> <20070511072939.GA25727@infradead.org> <20070511090127.GD9444@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511090127.GD9444@cvg>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 01:01:27PM +0400, Cyrill Gorcunov wrote:
> [Christoph Hellwig - Fri, May 11, 2007 at 08:29:39AM +0100]
> 
> ...
> 
> | And please get rid of the UDF_I_* macro for everything you touch, just
> | put a
> | 
> | 	struct udf_inode_info *uip = UDF_I(inode);
> | 
> | at the beginning of the function and use the fields directly.
> | 
> 
> Actually to properly remove UDF_I* and UDF_SB_* macroses in the
> whole UDF subsystem - is _lot_ of work. I'm going to make it but
> not now (too busy).

Doing it completely is a lot of work, yes.  I was more thinking of
converting a piece of code once you do major changes.  But if you
want to convert all the code as a separate patch I'm more than happy
aswell.
