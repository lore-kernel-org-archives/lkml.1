Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbZHFRFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbZHFRFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 13:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbZHFRFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 13:05:47 -0400
Received: from fieldses.org ([174.143.236.118]:57868 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222AbZHFRFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 13:05:46 -0400
Date: Thu, 6 Aug 2009 13:05:43 -0400
To: Sylvain Rochet <gradator@gradator.net>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: 2.6.28.9: EXT3/NFS inodes corruption
Message-ID: <20090806170543.GA32511@fieldses.org>
References: <20090716172749.GC3740@atrey.karlin.mff.cuni.cz> <20090725151751.GA6419@gradator.net> <20090727154253.GB8332@duck.suse.cz> <20090728112715.GA8442@gradator.net> <20090728135226.GA21682@duck.suse.cz> <20090728164142.GA13662@gradator.net> <20090803222901.GB23162@duck.suse.cz> <20090804111505.GA6433@gradator.net> <20090804225619.GB11097@duck.suse.cz> <20090806131555.GA23359@gradator.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806131555.GA23359@gradator.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 03:15:56PM +0200, Sylvain Rochet wrote:
> Hi,
> 
> 
> On Wed, Aug 05, 2009 at 12:56:19AM +0200, Jan Kara wrote:
> > 
> > Thanks for testing. So you seem to be really stressting the path where
> > creation of new files / directories fails (probably due to group quota).
> 
> Yes, there are 29 groups over quota on a total of 4499. Those are mainly 
> spammed websites and therefore quite stressed due to the amount of tries 
> to add new "data".
> 
> 
> > I have one idea what could cause your filesystem corruption, although 
> > it's a wild guess... Please try attached oneliner.
> 
> Running since yesterday.
> 
> 
> > Also your corruption reminded me that Al Viro has been fixing problems
> > where we could cache one inode twice when a filesystem was mounted over NFS
> > and that could also lead to a filesystem corruption. So I'm adding him to
> > CC just in case he has some idea. BTW Al, what do you think about the
> > problem I describe in the attached patch? I'm not sure if it can cause some
> > real problems but in theory it could...
> 
> Should we upgrade NFS clients as well ?  (now running 2.6.28.9)

The client version shouldn't matter.

--b.
