Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbYLMBNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbYLMBNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 20:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYLMBNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 20:13:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59053 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbYLMBNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 20:13:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081212190900.GL5691@genesis.frugalware.org>
References: <20081212190900.GL5691@genesis.frugalware.org> <20081212185347.GK5691@genesis.frugalware.org> <20081212182827.28408.40963.stgit@warthog.procyon.org.uk> <28996.1229108561@redhat.com>
To: Miklos Vajna <vmiklos@frugalware.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplified GIT usage guide
Date: Sat, 13 Dec 2008 01:12:56 +0000
Message-ID: <32096.1229130776@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Vajna <vmiklos@frugalware.org> wrote:

> > > Is there any reason you hide the tag object?
> > 
> > What's a tag object?
> 
> http://www.kernel.org/pub/software/scm/git/docs/gitglossary.html#def_tag_object

Okay.  I do mention tags.  How they're stored in the database is irrelevant.
As far as most users need be concerned, a tag is a symbolic representation of
a particular commit in the tree; a particular state of the source tree.

Think of symbolic links as an analogy.  Most users just need to know that a
symlink represents the location of another part of the VFS tree; actually most
users will just think of them as a pointer to the name of a file, if even that
much.  The fact that, say, ReiserFS tail packs them because they tend to be
small, or that AFS symlinks have weird properties that encode mountpoints is
irrelevant to most users.  You don't need to know that to use them.

Yes, GIT's database has blob objects, tree objects, commit objects and tag
objects; but as far as the normal user is concerned, it stores files, lists of
files (directories or, more probably, folders), commits and tags.  The
physical low-level stuff is completely irrelevant.

There is one exception to that: commit IDs.  These are public-facing as it
were.  GIT waves them in your face, and you have to use them occasionally, so
it's useful to say a bit about them.

David
