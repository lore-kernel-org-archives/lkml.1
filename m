Return-Path: <linux-kernel-owner+w=401wt.eu-S964812AbXIBVyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812AbXIBVyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 17:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbXIBVx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 17:53:58 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45115 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbXIBVx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 17:53:58 -0400
Date: Sun, 2 Sep 2007 17:53:51 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kyler-keyword-lkml.9c0da5@lairds.com, linux-kernel@vger.kernel.org
Subject: Re: Fw: 2.6.23-rc3-mm1 UnionFS "BUG: atomic counter underflow"
Message-ID: <20070902215351.GA23966@filer.fsl.cs.sunysb.edu>
References: <20070902045634.fd2d2a5f.akpm@linux-foundation.org> <20070902164835.GA19580@filer.fsl.cs.sunysb.edu> <20070902135957.e0903bbe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070902135957.e0903bbe.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2007 at 01:59:57PM -0700, Andrew Morton wrote:
> > On Sun, 2 Sep 2007 12:48:35 -0400 "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu> wrote:
> > On Sun, Sep 02, 2007 at 04:56:34AM -0700, Andrew Morton wrote:
> > > 
> > > fyi..
> >  
> > I got a bunch of patches queued up that should fix a few things - quite
> > possibly this one too.
> > 
> > I want to push the patches to korg, but in the mix is a fs/stack.c change &
> > corresponding ecryptfs fix that should go to Linus's tree. The rest of the
> > patches depend on this change.
> > 
> > How do you want me to do this? I guess I'll just send all of them to lkml,
> > and say which ones should go where in the 00/xx mail.
> 
> Let's do that as a starting point. 

Alright, I'll try to spam the lists later today.

> Perhaps we can fast-track the ecryptfs fix into mainline if it fixes
> something there.  
 
Not necessary, they aren't bugfixes for fsstack/ecryptfs.

> I don't want to kep the unionfs tree hanging around forever.  We need to
> work out whether we want to merge it.

Agreed.

Josef 'Jeff' Sipek.

-- 
Reality is merely an illusion, albeit a very persistent one.
		- Albert Einstein
