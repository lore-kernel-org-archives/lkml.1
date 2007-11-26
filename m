Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbXKZVwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbXKZVwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 16:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbXKZVwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:52:32 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47995 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751409AbXKZVwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:52:31 -0500
Date: Mon, 26 Nov 2007 13:52:31 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] x86 allnoconfig memory model
In-Reply-To: <20071126132036.343e3ee0.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711261351270.26057@schroedinger.engr.sgi.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
 <20071126111320.69d0aead.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0711261127250.23080@schroedinger.engr.sgi.com>
 <20071126124730.34c43da1.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0711261258480.25688@schroedinger.engr.sgi.com>
 <20071126132036.343e3ee0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Andrew Morton wrote:

> Unfortunately I just dropped that patch because git-x86 has gone and
> combined include/asm-x86/sparsemem_32.h and include/asm-x86/sparsemem_64.h
> into the same file.

git-x86 still contains separate sparsemem_32/64.h here.
git lag?

christoph@stapp:~/x86/linux-2.6-x86/.git$ cat config
[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[remote "origin"]
        url = 
git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
        fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
        remote = origin
        merge = refs/heads/master

