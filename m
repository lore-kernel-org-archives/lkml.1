Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbXEQO5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbXEQO5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbXEQO5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:57:37 -0400
Received: from verein.lst.de ([213.95.11.210]:54565 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbXEQO5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:57:37 -0400
Date: Thu, 17 May 2007 16:56:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Message-ID: <20070517145653.GA968@lst.de>
References: <20070517143200.GA30850@lst.de> <1179413443.3642.49.camel@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179413443.3642.49.camel@sauron>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 05:50:43PM +0300, Artem Bityutskiy wrote:
> Christoph,
> 
> On Thu, 2007-05-17 at 16:32 +0200, Christoph Hellwig wrote:
> > Kill ubis homegrown endianess handling crap and replace it with
> > the normal kernel endianess handling.
> 
> Err,__be32 and the company are just sparse things, while I have compiler
> checks with my struct ubi32_t and friends. JFFS2 also uses the same
> technique. Why do you force me to rely on sparse instead instead of
> compiler?

Yes.  Like all other code in the kernel aswell.

