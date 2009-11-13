Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbZKMUca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbZKMUca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 15:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbZKMUc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 15:32:29 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:58784 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbZKMUc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 15:32:28 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
Date: Fri, 13 Nov 2009 20:32:32 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hdkfp0$p9e$1@taverner.cs.berkeley.edu>
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk> <4AFC3620.2020809@schaufler-ca.com> <alpine.LRH.2.00.0911130833220.5497@tundra.namei.org> <4AFCC06B.1030302@schaufler-ca.com>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1258144352 25902 128.32.168.222 (13 Nov 2009 20:32:32 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Fri, 13 Nov 2009 20:32:32 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler  wrote:
>James Morris wrote:
>> Do you see potential for a buffer overrun in this case?
>
>No, but I hate arguing with people who think that every time
>they see strcmp that they have found a security flaw.

So don't argue with those people, then.  Those people are
probably deluded or ill-informed, if that's what they think every
time they see strcmp().

If you feel you absolutely must respond to them, send them here and
let them make the case for their position directly, with a concrete
technical argument -- if they have one (which I doubt).  Or, better yet,
ignore those people.  If they have a kneejerk reaction that "strcmp()
= security flaw", what makes you think they have anything useful to
contribute anyway?

I don't think this concern should have any weight whatsoever in the
decision on whether to patch the code.
