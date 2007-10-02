Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbXJBOUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbXJBOUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 10:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXJBOUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 10:20:08 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37643 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbXJBOUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 10:20:05 -0400
Subject: Re: [PATCH 07/30] IGET: Stop BEFS from using iget() and
	read_inode()
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Zach Brown <zab@zabbo.net>, Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, viro@ftp.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <25570.1191331457@redhat.com>
References: <1191330132.11136.2.camel@norville.austin.ibm.com>
	 <963DCFBD-9E68-488E-BD2C-D8B751E65BDF@zabbo.net>
	 <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
	 <20071001130958.29339.31669.stgit@warthog.procyon.org.uk>
	 <20071001173930.GA7718@mami.zabbo.net>
	 <alpine.LFD.0.999.0710011043250.3579@woody.linux-foundation.org>
	 <20071001180601.GA9417@infradead.org> <11826.1191328350@redhat.com>
	 <25570.1191331457@redhat.com>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 09:16:50 -0500
Message-Id: <1191334610.6252.0.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 14:24 +0100, David Howells wrote:
> Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> 
> > Of course, the cast is unnecessary,
> 
> The cast is necessary as the argument is a const pointer and the return type
> is not.

Ah yes.  I stand corrected.

-- 
David Kleikamp
IBM Linux Technology Center

