Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYLMXF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYLMXF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYLMXFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:05:10 -0500
Received: from vps1.tull.net ([66.180.172.116]:59638 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752053AbYLMXFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:05:09 -0500
Date: Sun, 14 Dec 2008 10:05:05 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: David Howells <dhowells@redhat.com>
Cc: Johannes Schindelin <Johannes.Schindelin@gmx.de>, torvalds@osdl.org,
       git@vger.kernel.org, linux-kernel@vger.kernel.org,
       Miklos Vajna <vmiklos@frugalware.org>
Subject: Re: [PATCH] Simplified GIT usage guide
Message-ID: <20081213230504.GA21912@mail.local.tull.net>
References: <alpine.DEB.1.00.0812121952320.5873@eeepc-johanness> <20081212182827.28408.40963.stgit@warthog.procyon.org.uk> <29095.1229109133@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29095.1229109133@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 07:12:13PM +0000, David Howells wrote:
> Johannes Schindelin <Johannes.Schindelin@gmx.de> wrote:

> > So I think that your document might do a good job scaring people away from 
> > Git.  But I do not believe that your document, especially in the tone it 
> > is written, does a good job of helping Git newbies.
> 
> Hmmm.  So what would you suggest is a good way to write for GIT newbies?  Is
> it just that the overview should be canned or drastically simplified?

The way I did it was to start with the directed acyclic graph of
commits, explaining how branches fork the graph and merges join
it. This was presented to people who know subversion, and so they
immediately became aware that there are other ways to manage source
code than in a linear r1 r2 r3 r4 r5. I described tags and branch
heads briefly.

Next up I described the things you'd do with git: add new commits,
create a branch, merge a branch, rebase, tag, push and fetch and
showed what that does with the dag of commits.

Finally I showed the actual commands used to perform those actions.
I didn't get into the object database structure at all (that was
prepared in case I had extra time).

I think a tutorial shouldn't be written in a way that polarises
peoples' opinions or they come to regard git as a "necessary evil".
If the audience is a person who knows nothing about git, that's
hardly a "git hater" and I think the document starts off on the
wrong foot as a result.

Nick.
