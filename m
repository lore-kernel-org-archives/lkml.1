Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbZFQS1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbZFQS1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZFQS0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:26:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49795 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbZFQS0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:26:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090617074711.GZ13073@webber.adilger.int>
References: <20090617074711.GZ13073@webber.adilger.int> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <20090616203901.4526.200.stgit@warthog.procyon.org.uk>
To: Andreas Dilger <adilger@sun.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, Wang Lei <wang840925@gmail.com>
Subject: Re: [PATCH 03/17] VFS: Implement handling for pathless pioctls
Date: Wed, 17 Jun 2009 19:26:37 +0100
Message-ID: <28511.1245263197@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger <adilger@sun.com> wrote:

> Wouldn't it make a lot more sense to create a virtual device, open the
> mountpoint, or do _something_ that associates these calls with AFS
> directly instead of having the kernel magically route the call to a
> specific filesystem?

Ummm...  You mean like mkdir, rmdir, symlink, readlink, mknod, creat, open,
unlink, etc. aren't magically routed by the kernel to a specific filesystem
based on the pathname?

The exception to that is pathless pioctls which are most annoying and require
special handling and foreknowledge whatever.

David
