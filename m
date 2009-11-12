Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbZKLXtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbZKLXtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbZKLXto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:49:44 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:36672 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713AbZKLXtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:49:43 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH 4/4] fs/qnx4: decrement sizeof size in strncmp
Date: Thu, 12 Nov 2009 23:49:49 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hdi6ut$cs9$1@taverner.cs.berkeley.edu>
References: <Pine.LNX.4.64.0911120849260.16627@ask.diku.dk>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1258069789 13193 128.32.168.222 (12 Nov 2009 23:49:49 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Thu, 12 Nov 2009 23:49:49 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall  wrote:
> As observed by Joe Perches, sizeof of a constant string includes the
> trailing 0.  If what is wanted is to check the initial characters of
> another string, this trailing 0 should not be taken into account.  If an
> exact match is wanted, strcmp should be used instead.
>
> The semantic patch that makes this change is as follows:

A caution: Your patch changes behavior.  Is there a specific reason
to believe that the change in behavior is what is desired/intended in
this context?  Lacking any analysis that indicates that the change in
behavior is desired, I'm skeptical that a behavior-changing patch should
be applied.
