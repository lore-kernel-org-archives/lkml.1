Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbXEBGFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbXEBGFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXEBGFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:05:52 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754812AbXEBGFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:05:51 -0400
Date: Tue, 1 May 2007 23:05:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davi Arnaut <davi@haxent.com.br>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 00/22] pollfs: filesystem abstraction for pollable
 objects
Message-Id: <20070501230529.424f17c6.akpm@linux-foundation.org>
In-Reply-To: <20070502052235.914764000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2007 02:22:35 -0300 Davi Arnaut <davi@haxent.com.br> wrote:

> This patch set introduces a new file system for the delivery of pollable
> events through file descriptors. To the detriment of debugability, pollable
> objects are a nice adjunct to nonblocking/epoll/event-based servers.
> 
> The pollfs filesystem abstraction provides better mechanisms needed for
> creating and maintaining pollable objects. Also the pollable futex approach
> is far superior (send and receive events from userspace or kernel) to eventfd
> and fixes (supercedes) FUTEX_FD at the same time.
> 
> The (non) blocking and object size (user <-> kernel) semantics and are handled
> internally, decoupling the core filesystem from the "subsystems" (mere push and
> pop operations).
> 
> Currently implemented waitable "objects" are: signals, futexes, ai/o blocks and
> timers.

Well that throws a spanner in the signalfd works.  The code _looks_ nice
and simple and clean from a quick scan.

David, could you provide some feedback please?  The patches are stunningly
free of comments, but you used to do that to me pretty often so my sympathy
is limited ;)


