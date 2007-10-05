Return-Path: <linux-kernel-owner+w=401wt.eu-S1763363AbXJEP32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763363AbXJEP32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758190AbXJEP3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:29:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60383 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409AbXJEP3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:29:17 -0400
Date: Fri, 5 Oct 2007 16:29:13 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, viro@ftp.linux.org.uk,
       torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/32] IGET: Mark iget() and read_inode() as being obsolete [try #2]
Message-ID: <20071005152913.GA6356@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>, viro@ftp.linux.org.uk,
	torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <9519.1191597148@redhat.com> <20071005144739.GC3072@infradead.org> <20071004155602.2814.47731.stgit@warthog.procyon.org.uk> <20071004155632.2814.55633.stgit@warthog.procyon.org.uk> <17504.1191597664@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17504.1191597664@redhat.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 04:21:04PM +0100, David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
> 
> > > Why do you move it out of line?
> > 
> > Because otherwise every file that gets compiled that includes linux/fs.h will
> > emit a warning that the implementation of that function is deprecated.
> 
> Or, rather, that read_inode() is deprecated.

So what about not actually marking it deprectated?  The last patch in the
series rips it out anyway (right so!)
