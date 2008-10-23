Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbYJWTXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbYJWTXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 15:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYJWTX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 15:23:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31971 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758778AbYJWTXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 15:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hmnUvNczbF2l+sxAnGZJzFNSP+mir356SXWqDdq3W481jxiroc9xXB2Y1zxOucI46o
         UP9/xbnzXKzG6as23Fr5hBm03rHu37a6s4OFXXqDeSuyD/8GPuTq8ZYE/IGDi1X3hS1X
         ZkB039vJPcANaZu4RorWzd623+Y8L7dIacbRM=
Date: Thu, 23 Oct 2008 23:26:30 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: wierd new config options
Message-ID: <20081023192630.GA23841@x200.localdomain>
References: <20081023181818.GA25430@lst.de> <1224789404.8230.158.camel@lts-notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224789404.8230.158.camel@lts-notebook>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 03:16:44PM -0400, Lee Schermerhorn wrote:
> On Thu, 2008-10-23 at 20:18 +0200, Christoph Hellwig wrote:
> > Why is UNEVICTABLE_LRU and option?  Is there any rason to turn it off or
> > is this just to confuse users?
> 
> 
> We discussed this back when we first submitted the patches.  I
> considered the NONRECLAIMABLE/UNEVICTABLE LRU mechanism to be a wee bit
> experimental at the time.  I wasn't sure that all platform that do want
> memory management would necessarily also want the unevictable lru.  It's
> easier for me to build it with the option and remove it later than vice
> versa.  If the consensus of the community is that it should always be
> enabled, then I'm fine with removing the option.  

The problem is that average admin can't make useful judgement on
this: active pageout lists -- what the hell is it?, kswapd -- ok, I
remember this process from ps(1) output, "will not waste" -- ok, good
thing, "will use one page flag" -- how many more I have?, what will
happen if they emptied?

And distro kernel maintainer should also make a decision -- not a module, after all.
