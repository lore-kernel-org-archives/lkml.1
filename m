Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbYFCQlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbYFCQlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 12:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYFCQlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 12:41:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58520 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbYFCQlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:41:10 -0400
Date: Tue, 3 Jun 2008 17:41:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Kent <raven@themaw.net>, Miklos Szeredi <miklos@szeredi.hu>,
       jesper@krogh.cc, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
Message-ID: <20080603164102.GB28946@ZenIV.linux.org.uk>
References: <20080603095713.GR28946@ZenIV.linux.org.uk> <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk> <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu> <20080603104035.GT28946@ZenIV.linux.org.uk> <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu> <20080603105258.GV28946@ZenIV.linux.org.uk> <1212499623.3025.46.camel@raven.themaw.net> <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org> <1212509263.3025.66.camel@raven.themaw.net> <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 09:35:47AM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 4 Jun 2008, Ian Kent wrote:
> > 
> > The code we're talking about deals with a race between expiring and
> > mounting an autofs mount point at the same time. 
> > 
> > I'll have a closer look and see if I can make it work without turning
> > the dentry negative.
> 
> Hmm.
> 
> Can you walk me through this?
> 
> If the dentry is unhashed, it means that it _either_
> 
>  - has already been deleted (rmdir'ed) or d_invalidate()'d. Right?
> 
>    I don't see why you should ever return the dentry in this case..

>From my reading of that code looks like it's been rmdir'ed.  And no, I
don't understand what the hell is that code trying to do.

Ian, could you describe the race you are talking about?
