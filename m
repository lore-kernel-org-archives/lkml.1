Return-Path: <linux-kernel-owner+w=401wt.eu-S1751831AbZKAJXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbZKAJXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 04:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbZKAJXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 04:23:30 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:48830 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZKAJX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 04:23:29 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: symlinks with permissions
Date: Sun, 1 Nov 2009 09:23:34 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hcjk2m$v46$1@taverner.cs.berkeley.edu>
References: <20091025062953.GC1391@ucw.cz> <4AE91658.9090105@schaufler-ca.com> <20091030140745.GC1481@ucw.cz> <4AEBB86F.3090601@schaufler-ca.com>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1257067414 31878 128.32.168.222 (1 Nov 2009 09:23:34 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sun, 1 Nov 2009 09:23:34 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler  wrote:
>Pavel Machek wrote:
>> Look again. I can count on paths if I can prevent mounts and
>> hardlinks.
>
> But you can't.

Yes, he can and did.  See Pavel's original post with his
attack script.  It's all there!

Hardlinks: in his *original* post, listing the attack script,
Pavel checks the hardlink count, which does defend against
hardlinks.  So can we drop the hardlink objection?

Mounts: can only be exploited by root.  On many Linux systems,
one cannot defend against a threat model where root is malicious,
and as a consequence, root-only attacks are out of scope for
those systems.  For those systems, this /proc mechanism is
a security hole: it enables attacker to do bad stuff they
couldn't have done without it.

> I refer you back to the long and tedious arguments
> against pathname based access controls.

I don't find that reference helpful.  Those arguments don't
seem relevant to this situation, as far as I can see.  I would
find specificity more useful than analogies.

Pavel has provided a concrete attack script.  If you believe
that the protections afforded by that script can be circumvented,
how about showing us the specific attack, described to a similar
level of concreteness and specifity, that demonstrates how to
upgrade the read-only fd to a read-write fd without using /proc?

Put another way: if you are right that the arguments about
pathname based access controls apply here and lead to the
conclusions you are espousing, then you should be able to
exhibit a specific, concrete, fully specified attack on Pavel's
script, without using /proc.  Right?
