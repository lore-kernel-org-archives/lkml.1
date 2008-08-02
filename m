Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYHBCbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYHBCbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 22:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYHBCaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 22:30:55 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:37723 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbYHBCay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 22:30:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FZrT2SM4+fZTBv0gqCyIdtP9AYdvEYwy8VPxnatvwMmGYM/0n1eBbD0M7saBTWP9Db
         pww9m0IBFXHyXEG2L+lg2jmD4R3Ngd6SVOiVn8uStc02KMJhGnsa6lFp0N3nG1V+9Mjy
         E+47QxxxjxDH76t+4QhegkXFq9/iIHDwOciww=
Date: Sat, 2 Aug 2008 06:30:40 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Ryan Hope <rmh3093@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: reiser4 for 2.6.27-rc1
Message-ID: <20080802023040.GB23534@martell.zuzino.mipt.ru>
References: <48f7fe350808010649l1111f48enbb6eca3cfcbba67f@mail.gmail.com> <20080801162548.GD8654@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801162548.GD8654@mit.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 12:25:48PM -0400, Theodore Tso wrote:
> On Fri, Aug 01, 2008 at 09:49:55AM -0400, Ryan Hope wrote:
> > Why is reiser4 still not in a vanilla kernel for testing. I have had
> > to apply the reiser4 patches from -mm kernels to vanilla based
> > patchset for over a year now. Reiser4 works fine, what will it take to
> > get it included in vanilla? Here is a patch to add reiser4 to
> > 2.6.27-rc1:
> > 
> > http://zen-sources.org/files/reiser4-for-2.6.27-rc1.patch
> 
> The reasons laid out in these web pages haven't changed.
> 
> http://kernelnewbies.org/WhyReiser4IsNotIn
> http://lkml.org/lkml/2006/7/28/180
> http://www.gossamer-threads.com/lists/engine?do=post_view_flat;post=668645;page=1;sb=post_latest_reply;so=ASC;mh=25;list=linux
> 
> Now that Hans is out of the picture, and Namesys seems to have
> collapsed, maybe someone can yank out the plugin architecture that
> Linus and others have objected to, which as near as I could tell was
> part of the Namesys's somewhat dodgy business plan of creating and
> selling (possibly proprietary; not sure what license they were going
> to be under) plugin modules for Reiser4 to make money.  The other
> issue that was raised during the review were some locking issues
> raised by Al Viro, if memory serves correctly.  I'm not sure if they
> were ever fixed;

	"That because the real plugins are long gone.  It's just that neither the
	complainers nor the fanboys in this thread ever read the code or generally
	had any clue of their own."
					--hch, 1 Aug 2006

