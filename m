Return-Path: <linux-kernel-owner+w=401wt.eu-S1763325AbXJNAMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763325AbXJNAMo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 20:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbXJNAMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 20:12:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35809 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747AbXJNAMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 20:12:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071013181137.GA9051@thunk.org>
References: <20071013181137.GA9051@thunk.org> <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, kwc@citi.umich.edu,
       Trond.Myklebust@netapp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/52] Introduce credential record
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Sat, 13 Oct 2007 22:46:15 +0100
Message-ID: <22130.1192311975@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> wrote:

>    I'm going to ask a stupid question, and I probably missed something
> in the 52 patches, but....  I see how the credential is used to do
> access checks, but why does the credentials record need to passed all
> the way into block allocator?  What is it used for there?

Ext2, 3 & 4 use it to determine whether someone has the right to use the
reserved space according to whether their UID/GID match those in the
superblock.

See ext3_has_free_blocks() for an example.

David
