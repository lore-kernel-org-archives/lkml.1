Return-Path: <linux-kernel-owner+w=401wt.eu-S1761560AbXJEMGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761560AbXJEMGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 08:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbXJEMF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 08:05:59 -0400
Received: from THUNK.ORG ([69.25.196.29]:40628 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbXJEMF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 08:05:58 -0400
Date: Fri, 5 Oct 2007 08:05:29 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Howells <dhowells@redhat.com>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 13/32] IGET: Stop EXT2 from using iget() and read_inode() [try #2]
Message-ID: <20071005120529.GA28985@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Howells <dhowells@redhat.com>, hch@infradead.org,
	viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk> <20071004155708.2814.8998.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004155708.2814.8998.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 04:57:08PM +0100, David Howells wrote:
> Stop the EXT2 filesystem from using iget() and read_inode().  Replace
> ext2_read_inode() with ext2_iget(), and call that instead of iget().
> ext2_iget() then uses iget_locked() directly and returns a proper error code
> instead of an inode in the event of an error.
> 
> ext2_fill_super() returns any error incurred when getting the root inode
> instead of EINVAL.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

							- Ted
