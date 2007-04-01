Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbXDAQDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbXDAQDW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 12:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933543AbXDAQDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 12:03:22 -0400
Received: from haxent.com ([65.99.219.155]:2895 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493AbXDAQDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 12:03:22 -0400
Message-Id: <20070401155810.277757000@haxent.com.br>
User-Agent: quilt/0.46-1
Date: Sun, 01 Apr 2007 12:58:10 -0300
From: davi@haxent.com.br
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 00/12] pollfs: a naive filesystem for pollable objects
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces a new file system for the delivery of pollable
events through file descriptors. To the detriment of debugability, pollable
objects are a nice adjunct to nonblocking/epoll/event-based servers.

Currently implemented waitable "objects" are: signals, futexes, ai/o blocks,
timers and fsync.

Very initial stage, it has only been slightly tested and isn't ready for prime.
The syscall wire up patches were skipped, the complete patch set can be found at:

http://haxent.com/~davi/pollfs/

Comments are welcome.

--
Davi Arnaut
