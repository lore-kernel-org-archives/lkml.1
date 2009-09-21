Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbZIUM35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbZIUM35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 08:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbZIUM34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 08:29:56 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:40906 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbZIUM3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 08:29:55 -0400
Subject: Re: [PATCH] VFS: document what MAY_ACCESS means
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jamie Lokier <jamie@shareable.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org
In-Reply-To: <20090921081047.GA20006@shareable.org>
References: <20090921012933.2631.85495.stgit@paris.rdu.redhat.com>
	 <20090921081047.GA20006@shareable.org>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 08:29:53 -0400
Message-Id: <1253536193.17222.21.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 7 msgs/h 2 sum rcpts/h 9 sum msgs/h 2 total rcpts 1506 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: E135708FC27FBF3856BD0DC985BBFC6B504E1CB2
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 260 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 09:10 +0100, Jamie Lokier wrote
> (Btw, side issue: I was very surprised to find fchdir() to an open
> directory can fail on NFS due to change of permissions, so the pattern
> dir = open("."); chdir("foo"); fchdir(dir) can fail to restore the
> current directory).

Welcome to the world of stateless server-enforced security. Unlike the
POSIX model, a NFS server doesn't have the ability to track what
permissions have already been checked using a file descriptor. It
therefore needs to check permissions on each RPC operation you perform
using the credential you present then and there.

Cheers
  Trond

