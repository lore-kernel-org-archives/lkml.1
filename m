Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbXJBM7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbXJBM7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 08:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbXJBM7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 08:59:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbXJBM67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 08:58:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071002100610.GA25647@atrey.karlin.mff.cuni.cz>
References: <20071002100610.GA25647@atrey.karlin.mff.cuni.cz> <20071001130921.29339.72876.stgit@warthog.procyon.org.uk> <20071001131018.29339.40931.stgit@warthog.procyon.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: dhowells@redhat.com, hch@infradead.org, viro@ftp.linux.org.uk,
       torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/30] IGET: Stop EXT2 from using iget() and read_inode()
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 02 Oct 2007 13:58:24 +0100
Message-ID: <21295.1191329904@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> wrote:

>   Hmm, why don't you use the return value from raw_inode? It can be
> either -EIO or -EINVAL if 'ino' was invalid...

Good point.  Altered.

David
