Return-Path: <linux-kernel-owner+w=401wt.eu-S1761217AbZFPXAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761217AbZFPXAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 19:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbZFPXAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 19:00:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35485 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbZFPXAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 19:00:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-afs@lists.infradead.org
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
Date: Tue, 16 Jun 2009 23:59:52 +0100
Message-ID: <10437.1245193192@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Howells <dhowells@redhat.com> wrote:

> This series of patches provides a pioctl() system call, and makes kAFS use it
> to provide a number of of the OpenAFS pioctl functions sufficient to allow a
> number of OpenAFS userspace utilities work with kAFS.

The point of this is to permit unmodified OpenAFS userspace utilities to use
either the OpenAFS kernel module or the kAFS kernel module.

Whilst I might wish to ultimately replace the OpenAFS userspace utilities with
my own set, that's no small piece of work, and so a handy halfway stage is a
mixed environment as outlined above.

Furthermore, the ability to use the OpenAFS userspace utilities unmodified
with my kernel module, and, indeed vice-versa, makes testing much easier.

David
