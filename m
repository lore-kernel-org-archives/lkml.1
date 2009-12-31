Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbZLaRwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbZLaRwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 12:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZLaRwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 12:52:15 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:36984 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZLaRwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 12:52:14 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [RFC][PATCH v3] Unprivileged: Disable raising of privileges
Date: Thu, 31 Dec 2009 17:52:14 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hhioce$j9t$2@taverner.cs.berkeley.edu>
References: <m1iqbpwjtp.fsf@fess.ebiederm.org> <20091230230042.5d2e78ac@lxorguk.ukuu.org.uk> <3e8340490912301844p4fddaf57ke58ceeba9582e0fa@mail.gmail.com> <20091231173334.5e3d7557@lxorguk.ukuu.org.uk>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1262281934 19773 128.32.153.193 (31 Dec 2009 17:52:14 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Thu, 31 Dec 2009 17:52:14 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox  wrote:
>Look up the sendmail security archive and you'll even find examples where
>enforcing extra security on setuid *caused* security problems to show up
>that were basically impossible to hit otherwise.

Yes, we know: people have mentioned the sendmail bug multiple times
in this thread.  That's exactly the hazard that this proposed patch
was intended to help address.  That's exactly the hazard that all
this discussion has been focused on.

This patch is not a security model.  It may facilitate other
security models, hopefully, but it's not intended as a security
model in itself.

>We have a security system, with a set of interfaces for attaching
>security models, please stop trying to go round the back of the kernel
>design because you can't be bothered to do the required work to do the
>job right and would rather add more unmaintainable crap all over the
>place.

Got a constructive suggestion for a better way to implement this?
My impression is that all thread participants have been happy to
listen to constructive suggestions about alternative ways to achieve
the goals, from people who have payed attention to the discussion and
taken the time to understand the points that havee been raised so far.
