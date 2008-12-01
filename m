Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYLART1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYLART1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 12:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYLARTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 12:19:16 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:41148 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYLARTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 12:19:15 -0500
X-Greylist: delayed 1453 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Dec 2008 12:19:15 EST
Date: Mon, 1 Dec 2008 11:54:43 -0500
Message-Id: <200812011654.mB1GshRh023996@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: bharata@linux.vnet.ibm.com
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       jblunck@suse.de, dlezcano@fr.ibm.com, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [rfc git patch] union directory 
In-reply-to: Your message of "Fri, 28 Nov 2008 21:49:21 +0530."
             <20081128161921.GA3843@in.ibm.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20081128161921.GA3843@in.ibm.com>, Bharata B Rao writes:
> On Fri, Nov 28, 2008 at 12:01:32PM +0100, Miklos Szeredi wrote:
> > I've been doing some small fixing/cleanup work on the union directory
> > patches by Jan, and just noticed there's a thread about the union
> > mounts on LKML, so I thought publicizing won't hurt.
> 
> Interesting that you call it "union directory", do you have plans to go
> the Plan 9's way of union directories ?
> 
> > 
> > It's still a work in progress, notably the readdir code currently only
> > works on a few specific filesystem types.
> 
> readdir was one of the things on which we couldn't reach a consensus
> on how to do it the right way. We were suggested that we move the
> duplicate elimination into user space and an effort towards this was
> also done (Ref: http://lkml.org/lkml/2008/4/29/248) by moving this
> to glibc readdir. But we weren't sure how this could work for NFS and
> were told that it is required to get the NFS side of things
> sorted out first. So that's where readdir effort stands now afaik.
> Do you have any ideas/plans on this front ?
> 
> Also the last development activity that I am aware of was done towards
> getting a generic whiteout support. David Woodhouse started a git tree
> at one point of time for whiteout support
> (git://git.infradead.org/union/whiteout-2.6.git). Erez Zodak was
> infact looking forward for these changes to make use of them in Unionfs,
> but even this effort died down.

We've actually been (quietly) looking into these whiteout patches for a
couple of months already.  We found that those patches were not yet suitable
for intergration into a f/s such as unionfs.  We found (and fixed) some
bugs, and had to change the API somewhat and its implementation.  I think
the only way to be sure that these patches work well is to have a user for
them.  We plan on re-posting our modified patches once we've done a lot more
testing with them in the context of unionfs.

> Nice to know that you have started looking into Union Mount patches.
> Would be interesting to know/understand your plans/thoughts on taking
> this effort forward.
> 
> Regards,
> Bharata.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Erez.
