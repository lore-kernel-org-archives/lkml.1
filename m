Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbZDKUm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbZDKUm5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 16:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZDKUmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 16:42:45 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:40088 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbZDKUmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 16:42:45 -0400
Date: Sat, 11 Apr 2009 22:44:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jike Song <albcamus@gmail.com>, David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MN10300: Move arch headers to arch dir
Message-ID: <20090411204448.GA2784@uranus.ravnborg.org>
References: <19057.1239370935@redhat.com> <20090410192529.GA25551@uranus.ravnborg.org> <df9815e70904102042r2cd2e3e3ue6159f348e4c192e@mail.gmail.com> <20090411054516.GA29493@uranus.ravnborg.org> <20090411064300.GT26366@ZenIV.linux.org.uk> <20090411075549.GA30873@uranus.ravnborg.org> <20090411153933.GU26366@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090411153933.GU26366@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 04:39:33PM +0100, Al Viro wrote:
> On Sat, Apr 11, 2009 at 09:55:49AM +0200, Sam Ravnborg wrote:
> > > How about a single directory for *all* generated headers?  Only linux/version.h
> > > has many places including it and even that can be dealt with for a moment with
> > > linux/version.h consisting of #include <gen/version.h>.  The rest doesn't
> > > need anything like that even for transition period - too few includes to care.
> > 
> > So you suggest: include/gen/
> 
> Yes.

I will work on a patch and cc: you on it when it is mainline ready.
It looks trivial.

I need to get my resurrected build box working first though so it
will take a few days/weeks before I am on it.

	Sam
