Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbZJWWzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbZJWWzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 18:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbZJWWzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 18:55:52 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:42911 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbZJWWzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 18:55:52 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: SECURITY PROBLEM: filesystem permiossion bypass on FD already opened
Date: Fri, 23 Oct 2009 22:55:57 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hbtc9t$629$1@taverner.cs.berkeley.edu>
References: <4AE20B6F.4060606@ntd.homelinux.org>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1256338557 6217 128.32.168.222 (23 Oct 2009 22:55:57 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Fri, 23 Oct 2009 22:55:57 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NiTRo  wrote:
>    Just discovered this security problem [...]
>If a FD is opened on a allowed file and then the permission is changed
>the file is still redeable starting from the already read position to
>the EOF.

This is not a security problem; this is Unix working as designed.
That's how file descriptors work.  File permissions are checked when
the file is opened, not on every read/write to the file descriptor.
That's a pretty fundamental aspect of how Unix works, and it is
well-documented and well-understood.

On the other hand, the /proc attack that Pavel explains *is* a
security problem.  But that's different.
