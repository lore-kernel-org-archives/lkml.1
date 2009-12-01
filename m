Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbZLAQFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbZLAQFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbZLAQFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:05:48 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:56862 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbZLAQFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:05:48 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [Patch] net: fix an array index overflow
Date: Tue, 1 Dec 2009 16:05:54 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hf3et2$2da$1@taverner.cs.berkeley.edu>
References: <20091201082901.4678.16688.sendpatchset@localhost.localdomain>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1259683554 2474 128.32.168.222 (1 Dec 2009 16:05:54 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Tue, 1 Dec 2009 16:05:54 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang  wrote:
> Don't use the address of an out-of-boundary element.

Why not?  There is nothing wrong with using a pointer to an element
one-past-the-end in this way.  It's idiomatic C.
