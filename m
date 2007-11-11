Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbXKKOAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbXKKOAB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 09:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbXKKN7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 08:59:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbXKKN7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 08:59:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071111112538.GL21669@stusta.de>
References: <20071111112538.GL21669@stusta.de> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153437.20803.55096.stgit@warthog.procyon.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if !CONFIG_BINFMT_AOUT [try #5]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Sun, 11 Nov 2007 13:59:29 +0000
Message-ID: <1505.1194789569@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> - too many cleanups lumped into one patch

Perhaps, but unfortunately a lot of them are related and required for a
compilable patch.  I can probably split it up 4 ways if you really want me
to, in order:

 (1) Move STACK_TOP[_MAX].

 (2) Rename dump_thread() -> aout_dump_thread().

 (3) Everything else.

 (4) Remove obsolete a.out.h inclusions.

I don't think it's really worth splitting (2) from (3) though.

> - it adds #ifdef's in fs/binfmt_elf.c for code that is anyway
>   scheduled for removal in 2.6.25

Yes, but that patch isn't there now, and won't be there in the next version -
assuming this arch has a hope of getting in on that one - according to your
statement.

David
