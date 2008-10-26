Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbYJZQFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbYJZQFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 12:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbYJZQFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 12:05:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48066 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076AbYJZQFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 12:05:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081026225324.6231397d.sfr@canb.auug.org.au>
References: <20081026225324.6231397d.sfr@canb.auug.org.au> <20081025130851.379cfac0.sfr@canb.auug.org.au> <20081024174838.GA24466@us.ibm.com> <11290.1224873841@redhat.com> <10752.1225019273@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, jmorris@us.ibm.com
Subject: Re: [PATCH] User namespaces: set of cleanups (v2)
Date: Sun, 26 Oct 2008 16:04:55 +0000
Message-ID: <11588.1225037095@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Yes. Or whatever it is based on now if that merges OK with Linus' head
> (try a test merge).  Just don't base on linux-next :-)

It's based on Linus's head at the moment, give or take the last few bits he
pulled in which I haven't dealt with yet.

> What I want is exactly what you will ask/have asked Linus to fetch but
> without the branch name changing .. I care more about the name changing
> than the contents changing.
> 
> So .. what branch do I fetch tomorrow?  (Hint: if you have your version
> for Linus checked out then type "git branch next" and reply to this email
> saying "next" :-))

I asked him to pull creds-v4 last:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/cred-2.6.git;a=shortlog;h=creds-v4

I'd quite like to amend the name of the branch to something more sensible,
since the 'v<N>' represented new versions based on fixing up merges with
Linus's tree rather than changing my patches.

However, if you'd rather I just threw new merges on top of that, then I can do
that - it's just got a silly branch name.

Alternatively, if you'd rather James pulled it into his 'next' branch, he
might be amenable to that.

David
