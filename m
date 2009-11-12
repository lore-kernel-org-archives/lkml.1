Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZKLX5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZKLX5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:57:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbZKLX45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:56:57 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:42004 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbZKLX4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:56:50 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
Date: Thu, 12 Nov 2009 23:56:53 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hdi7c5$csj$1@taverner.cs.berkeley.edu>
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk> <4AFC3620.2020809@schaufler-ca.com> <alpine.LRH.2.00.0911130833220.5497@tundra.namei.org> <Pine.LNX.4.64.0911122257090.432@ask.diku.dk>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1258070213 13203 128.32.168.222 (12 Nov 2009 23:56:53 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Thu, 12 Nov 2009 23:56:53 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall  wrote:
> Is it possible for the 0 at the end of an explicit constant string
> to get overwritten?

I don't see any way it could in this case.  If there were some other
bug that allowed overwriting the explicit constant string, we'd want
to fix that other bug, but I don't see anything like that in this case.
