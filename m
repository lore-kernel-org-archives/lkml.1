Return-Path: <linux-kernel-owner+w=401wt.eu-S1757683AbXEQSNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbXEQSNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbXEQSNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:13:13 -0400
Received: from verein.lst.de ([213.95.11.210]:33399 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbXEQSNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:13:12 -0400
Date: Thu, 17 May 2007 20:12:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, dedekind@infradead.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Message-ID: <20070517181223.GA17765@lst.de>
References: <20070517143200.GA30850@lst.de> <1179417055.2859.506.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179417055.2859.506.camel@shinybook.infradead.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 11:50:54PM +0800, David Woodhouse wrote:
> On Thu, 2007-05-17 at 16:32 +0200, Christoph Hellwig wrote:
> > Kill ubis homegrown endianess handling crap and replace it with
> > the normal kernel endianess handling. 
> 
> NAK. The 'normal' kernel stuff doesn't work in GCC; only in sparse.
> 
> If you want to go removing the ones which _do_ work in GCC, then fix the
> 'normal' one first. _Then_ go about converting others over to it.

Nope.  gcc checking is crap and we need to run sparse anyway.  It's what
everyone in the kernel use so it's perfect for some random code almost
no one uses aswell.
