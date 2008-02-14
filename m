Return-Path: <linux-kernel-owner+w=401wt.eu-S1763482AbYBNKx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763482AbYBNKx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 05:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYBNKxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 05:53:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbYBNKxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 05:53:47 -0500
Subject: Re: gfs2_fh_to_parent() array overflow
From: Steven Whitehouse <swhiteho@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080213213112.GU3383@cs181133002.pp.htv.fi>
References: <20071024162626.GJ30533@stusta.de>
	 <20071027210039.GA2688@lst.de> <1193649081.1068.462.camel@quoit>
	 <20080213213112.GU3383@cs181133002.pp.htv.fi>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Thu, 14 Feb 2008 10:44:34 +0000
Message-Id: <1202985874.22038.455.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2008-02-13 at 23:31 +0200, Adrian Bunk wrote:
> On Mon, Oct 29, 2007 at 09:11:21AM +0000, Steven Whitehouse wrote:
> > Hi,
> > 
> > On Sat, 2007-10-27 at 23:00 +0200, Christoph Hellwig wrote:
> > > On Wed, Oct 24, 2007 at 06:26:26PM +0200, Adrian Bunk wrote:
> > > > The Coverity checker spotted the following array overflow caused by
> > > > commit 34c0d154243dd913c5690ae6ceb9557017429b9c:
> > > 
> > > The line is a left-over from times when gfs stored the mode of the
> > > inode in the file handle.  It can simply be deleted.  Steve, do you
> > > want a patch for that or could you commit that one-liner directly?
> > > 
> > 
> > I'm just back from holiday this morning and this is looking a bit more
> > complicated than that... give me a day or two and I'll try and come up
> > with a solution,
> 
> This issue is still present in 2.6.25-rc1.
> 
Yes, it seems to have slipped off my list somehow... I've opened a bz
(#432775 at bugzilla.redhat.com) to ensure that it doesn't get missed
again,

Steve.


