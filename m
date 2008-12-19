Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbYLSGcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbYLSGcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 01:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYLSGcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 01:32:10 -0500
Received: from 1wt.eu ([62.212.114.60]:1071 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYLSGcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 01:32:09 -0500
Date: Fri, 19 Dec 2008 07:33:02 +0100
From: Willy Tarreau <w@1wt.eu>
To: sverre@rabbelier.nl
Cc: David Howells <dhowells@redhat.com>, Jakub Narebski <jnareb@gmail.com>,
       torvalds@osdl.org, git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplified GIT usage guide
Message-ID: <20081219063301.GA6800@1wt.eu>
References: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk> <m33agtgp2v.fsf@localhost.localdomain> <32073.1229130284@redhat.com> <bd6139dc0812121716w73ea1145w7f870e887e00adc0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd6139dc0812121716w73ea1145w7f870e887e00adc0@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 02:16:34AM +0100, Sverre Rabbelier wrote:
> On Sat, Dec 13, 2008 at 02:04, David Howells <dhowells@redhat.com> wrote:
> >  (3) You put some non-basic stuff in the basic section (branching - this isn't
> >     ordinarily useful, IMHO), but you miss other stuff out ('git rm' for
> >     example).
> 
> Erm, branching is not ordinarily useful? I think you're Doing It Wrong
> (TM) then, since branching is a Big Thing (also TM) in DVC, not using
> branches would be a bit like only using the first 4 gears in a car;
> sure, it's possible, but you're missing all that extra power!

People who want to use it as a CVS replacement don't realize that they're
using branches. They work in their local "master" branch, and don't realize
that when they fetch updates, they fetch them into a different branch.

CVS people are afraid of branches, so trying to explain them how they can
do what they're used to is better than telling them they'll have to do
what they're afraid of.

I found David's howto quite understandable. I've taught Git to people who
only knew about SVN and to people who had never heard about any SCM at all. I
tried to use the same approach each time, and while I noticed that explaining
how Git works and why it works like that appeared obvious to the newbies,
it was very awkward with SVN users. I switched to something more like
David's approach for those people and it helped a lot. They have plenty
of time after that to discover the tool by themselves.

I really think that David should maintain his doc after applying a few
fixes to it, just like Jeff maintains his own. Also, having several docs
out of the tree is better for a user looking for different analysis of
the tool than having everything offered as the product's documentation,
provided the links are easy to find (might be linked to from the Git doc).

Willy

