Return-Path: <linux-kernel-owner+w=401wt.eu-S1763000AbXJEPM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763000AbXJEPM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbXJEPMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:12:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbXJEPMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:12:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071005144739.GC3072@infradead.org>
References: <20071005144739.GC3072@infradead.org> <20071004155602.2814.47731.stgit@warthog.procyon.org.uk> <20071004155632.2814.55633.stgit@warthog.procyon.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, torvalds@osdl.org,
       akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/32] IGET: Mark iget() and read_inode() as being obsolete [try #2]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Fri, 05 Oct 2007 16:12:28 +0100
Message-ID: <9519.1191597148@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote:

> Why do you move it out of line?

Because otherwise every file that gets compiled that includes linux/fs.h will
emit a warning that the implementation of that function is deprecated.

David
