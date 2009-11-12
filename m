Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbZKLS17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbZKLS17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZKLS15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:27:57 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:49651 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbZKLS15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:27:57 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
Date: Thu, 12 Nov 2009 18:28:03 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hdhk3j$9hl$1@taverner.cs.berkeley.edu>
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk> <20091112145314.GA24682@us.ibm.com> <Pine.LNX.4.64.0911121556390.19779@ask.diku.dk> <4AFC3620.2020809@schaufler-ca.com>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1258050483 9781 128.32.168.222 (12 Nov 2009 18:28:03 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Thu, 12 Nov 2009 18:28:03 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler  wrote:
> I strongly suggest that this is not what is wanted.
>     strcmp(x,y)
> and
>     strncmp(x,y,sizeof(y))
>
> are functionally equivalent and strcmp has a bad reputation in
> the security community because it is associated with potential
> buffer overrun issues.

It does?  Hmm, I don't recall hearing of this bad reputation for strcmp().
Is there a justification for why such a reputation would be deserved?
We're not talking strcpy() here.  strcmp() is fine as long as its
arguments are properly '\0'-terminated; given that, it doesn't introduce
any new buffer overrun risks.
