Return-Path: <linux-kernel-owner+w=401wt.eu-S932528AbZKMXG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbZKMXG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932471AbZKMXGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:06:25 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:32889 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485AbZKMXGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:06:24 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
Date: Fri, 13 Nov 2009 23:06:28 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hdkopk$qk3$1@taverner.cs.berkeley.edu>
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk> <alpine.LRH.2.00.0911130833220.5497@tundra.namei.org> <4AFCC06B.1030302@schaufler-ca.com> <19857.1258147396@turing-police.cc.vt.edu>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1258153588 27267 128.32.168.222 (13 Nov 2009 23:06:28 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Fri, 13 Nov 2009 23:06:28 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The biggest problem with strcmp() is that even if it got audited when
> that code went in, it's prone to unaudited breakage when somebody changes
> something in some other piece of code, quite often in some other .c file
> in some other directory.

I don't understand what concern you are ferring to.  Could you explain?
What is special about strcmp() that requires auditing?  What kind of
breakage are you talking about?

Are you just referring to the fact that strcmp() assumes its strings
are '\0'-terminated?  Do you have the same concern about every library
function that handles '\0'-terminated strings?  Does your concern apply
to this particular code snippet, where the call is (or would be) of the
form strcmp(s, "string constant")?  Does your concern apply equally to
strncmp(s, "string constant", sizeof("string constant"))?
