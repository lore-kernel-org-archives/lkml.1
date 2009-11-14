Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbZKNDoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbZKNDoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 22:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757182AbZKNDoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 22:44:09 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:41360 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373AbZKNDoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 22:44:09 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
Date: Sat, 14 Nov 2009 03:44:14 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hdl92e$srv$1@taverner.cs.berkeley.edu>
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk> <4AFCC06B.1030302@schaufler-ca.com> <19857.1258147396@turing-police.cc.vt.edu> <4AFE1EA9.60102@schaufler-ca.com>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1258170254 29567 128.32.168.222 (14 Nov 2009 03:44:14 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sat, 14 Nov 2009 03:44:14 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler  wrote:
> No, but I hate arguing with people who think that every time
> they see strcmp that they have found a security flaw.

Valdis.Kletnieks@vt.edu wrote:
> How do you feel about people who think every time they see strcmp()
> "Oh crap, something that needs auditing"? ;)

Casey Schaufler  wrote:
> They have my deep sympathy. Which is why I'm advocating leaving
> the perfectly functional and correct use of strncmp() as it is.

Personally, I think this is catering to irrational kneejerk responses,
from hypothetical people who may or may not exist.  I have yet to see a
single person stand up on the linux-kernel mailing list, endorse such
a position, and put their own name behind it.  That's no surprise,
because it looks to me like an illogical and unjustified position that
would reflect poorly on anyone who adopted such a position in this case.
I do not think it makes sense to make a decision based upon the hypothesis
that maybe unidentified others will think that way, particularly when
no one can put forward a convincing argument that "thinking that way"
is reasonable in light of the technical facts.

I personally don't find
    strncmp(foo, "constant", sizeof("constant"))        // first snippet
to be more readable, auditable, or obviously correct than
    strcmp(foo, "constant").                            // second snippet
Do you?  Does anyone?

Of course, those two code snippets have exactly the same behavior, so
there is no difference in their actual security properties.  The only
possible difference I can imagine would be if one code snippet is
more readable, intuitive, or obviously correct than the other -- but I
would think strcmp() is no worse under those criteria, and if anything
modestly better.  Is there a technical basis for arguing that the first
snippet is better than the second snippet?
