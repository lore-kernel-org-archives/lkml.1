Return-Path: <linux-kernel-owner+w=401wt.eu-S1422894AbXDTFiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422894AbXDTFiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422895AbXDTFiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:38:16 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59740 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422894AbXDTFiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:38:16 -0400
Date: Thu, 19 Apr 2007 22:38:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Neil Brown <neilb@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: SLUB: kmem_cache_destroy doesn't - version 2.
In-Reply-To: <17960.20796.761309.771912@notabene.brown>
Message-ID: <Pine.LNX.4.64.0704192236510.16503@schroedinger.engr.sgi.com>
References: <17960.16739.870487.497750@notabene.brown>
 <Pine.LNX.4.64.0704192215420.16306@schroedinger.engr.sgi.com>
 <17960.20796.761309.771912@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Neil Brown wrote:

> On Thursday April 19, clameter@sgi.com wrote:
> > On Fri, 20 Apr 2007, Neil Brown wrote:
> > 
> > > Not sure how best to fix this one.... kmem_cache_destroy currently
> > > doesn't know which alias is being destroyed.
> > 
> > The aliases are there for decorative purposes when running without
> > debugging. If one switches on debugging then it matters but then the
> > symlinks are not created since there will be no aliases.
> > 
> > I guess we can ignore the problem?
> 
> Maybe....
> But then if we create the same cache with a different size, we might
> need to create a directory in sysfs, but there is already a symlink
> there... 
> It doesn't feel very clean.

Right. Sigh. But there is no user of the symlinks.

I could drop the symlinks completely. Just do not track what names a cache 
aliases to?


