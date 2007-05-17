Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbXEQUmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbXEQUmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbXEQUmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:42:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34577 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640AbXEQUmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:42:39 -0400
Date: Thu, 17 May 2007 21:42:34 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dedekind@infradead.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Message-ID: <20070517204234.GR4095@ftp.linux.org.uk>
References: <20070517143200.GA30850@lst.de> <1179413443.3642.49.camel@sauron> <20070517145653.GA968@lst.de> <1179414590.3642.69.camel@sauron> <20070517102931.6bbbad1a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517102931.6bbbad1a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 10:29:31AM -0700, Andrew Morton wrote:
> On Thu, 17 May 2007 18:09:50 +0300 Artem Bityutskiy <dedekind@infradead.org> wrote:
> 
> > On Thu, 2007-05-17 at 16:56 +0200, Christoph Hellwig wrote:
> > > On Thu, May 17, 2007 at 05:50:43PM +0300, Artem Bityutskiy wrote:
> > > > Christoph,
> > > > 
> > > > On Thu, 2007-05-17 at 16:32 +0200, Christoph Hellwig wrote:
> > > > > Kill ubis homegrown endianess handling crap and replace it with
> > > > > the normal kernel endianess handling.
> > > > 
> > > > Err,__be32 and the company are just sparse things, while I have compiler
> > > > checks with my struct ubi32_t and friends. JFFS2 also uses the same
> > > > technique. Why do you force me to rely on sparse instead instead of
> > > > compiler?
> > > 
> > > Yes.  Like all other code in the kernel aswell.
> > 
> > Andrew, may I please have your ack that I absolutely have to use __be32
> > instead of my own types since Christoph tends to provide no explanation
> > to his requests.
> 
> umm..  I'd say what you've done in there is an improvement to the exiting
> stuff: getting gcc to check it is better than having to use sparse.

Ahem...  So what does
	x |= y;
turns into with that approach?
