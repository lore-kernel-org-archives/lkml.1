Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbXKZV6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbXKZV6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 16:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbXKZV63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:58:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34737 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754588AbXKZV62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:58:28 -0500
Date: Mon, 26 Nov 2007 13:57:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] x86 allnoconfig memory model
Message-Id: <20071126135756.980c7072.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0711261351270.26057@schroedinger.engr.sgi.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<20071126111320.69d0aead.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0711261127250.23080@schroedinger.engr.sgi.com>
	<20071126124730.34c43da1.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0711261258480.25688@schroedinger.engr.sgi.com>
	<20071126132036.343e3ee0.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0711261351270.26057@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 13:52:31 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Mon, 26 Nov 2007, Andrew Morton wrote:
> 
> > Unfortunately I just dropped that patch because git-x86 has gone and
> > combined include/asm-x86/sparsemem_32.h and include/asm-x86/sparsemem_64.h
> > into the same file.
> 
> git-x86 still contains separate sparsemem_32/64.h here.
> git lag?

yup

> christoph@stapp:~/x86/linux-2.6-x86/.git$ cat config
> [core]
>         repositoryformatversion = 0
>         filemode = true
>         bare = false
>         logallrefupdates = true
> [remote "origin"]
>         url = 
> git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
>         fetch = +refs/heads/*:refs/remotes/origin/*
> [branch "master"]
>         remote = origin
>         merge = refs/heads/master

git+ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git#mm

a) I use the #mm branch

b) I go direct to master.kernel.org.  Probably that's only worth five
minutes nowadays - it used to be worth hours, but kernel.org got better.
