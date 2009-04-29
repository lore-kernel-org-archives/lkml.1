Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbZD2Hz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbZD2Hz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZD2HzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:55:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbZD2HzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:55:06 -0400
Date: Wed, 29 Apr 2009 00:52:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: origin tree build warnings
Message-Id: <20090429005210.3dd9166e.akpm@linux-foundation.org>
In-Reply-To: <20090429144436.e821c0f1.sfr@canb.auug.org.au>
References: <20090429144436.e821c0f1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 14:44:36 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Tyler,
> 
> Today's linux-next build (x86_64 allmodconfig) generated these warnings:
> 
> fs/ecryptfs/inode.c: In function 'ecryptfs_readlink':
> fs/ecryptfs/inode.c:670: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
> fs/ecryptfs/inode.c:693: warning: comparison of distinct pointer types lacks a cast
> 
> Caused by commit 3a6b42cadc112b01daf0525e5fcd90bb333a5bb3 ("eCryptfs:
> Larger buffer for encrypted symlink targets").

yup, Randy sent a fix for this today.

I merged that patch and put it into my "to be merged into 2.6.30 via
the ecryptfs tree" pile.

Tyler, if you can't be bothered setting up a git pull for a one-liner
then feel free to tell me to merge it.

If you don't do that then I tend to end up sitting on the patch for
rather a while, sending it at the tree maintainer once every couple of
weeks.  Sometimes I end up sitting on them after the major kernel
release, after having sent them to the maintainer several times, which
is all very sad.  Sometimes I'll get bored of sending them at the
maintainer and I'll just merge them anyway, depending upon how frisky
I'm feeling.
