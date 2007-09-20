Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbXITH3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbXITH3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbXITH3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:29:20 -0400
Received: from tech.netart.pl ([85.128.128.114]:40365 "EHLO tech.serwery.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473AbXITH3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:29:19 -0400
Date: Thu, 20 Sep 2007 09:29:14 +0200
From: NetArt - Grzegorz Nosek <grzegorz.nosek@netart.pl>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NFS + coredump OOPS
Message-ID: <20070920072914.GA11115@tech.serwery.pl>
References: <20070919105353.GA7392@tech.serwery.pl> <1190225233.6734.8.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190225233.6734.8.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 02:07:13PM -0400, Trond Myklebust wrote:
> On Wed, 2007-09-19 at 12:53 +0200, NetArt - Grzegorz Nosek wrote:
> > [16249868.626066] ------------[ cut here ]------------
> > [16249868.684345] kernel BUG at mm/readahead.c:314!
> 
> That bug should have been fixed in 2.6.19-rc5. See 
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=029e332ea717810172e965ec50f942755ad0c58a
> 
> Cheers
>   Trond

Thanks! Is this single commit safe to apply on older kernels (we're on
2.6.18.y for the time being), or does it depend on other changes?

Best regards,
 Grzegorz Nosek

