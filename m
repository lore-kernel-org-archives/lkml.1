Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbXJBN1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbXJBN1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 09:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbXJBN1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 09:27:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbXJBN1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 09:27:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1191330132.11136.2.camel@norville.austin.ibm.com>
References: <1191330132.11136.2.camel@norville.austin.ibm.com> <963DCFBD-9E68-488E-BD2C-D8B751E65BDF@zabbo.net> <20071001130921.29339.72876.stgit@warthog.procyon.org.uk> <20071001130958.29339.31669.stgit@warthog.procyon.org.uk> <20071001173930.GA7718@mami.zabbo.net> <alpine.LFD.0.999.0710011043250.3579@woody.linux-foundation.org> <20071001180601.GA9417@infradead.org> <11826.1191328350@redhat.com> 
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, Zach Brown <zab@zabbo.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, viro@ftp.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/30] IGET: Stop BEFS from using iget() and read_inode()
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 02 Oct 2007 14:24:17 +0100
Message-ID: <25570.1191331457@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:

> Of course, the cast is unnecessary,

The cast is necessary as the argument is a const pointer and the return type
is not.

> and I'm sure you meant to return error:

Oops.  Yes, I changed my mind and renamed the argument to be 'error', but
forgot to change the reference to it.

David
