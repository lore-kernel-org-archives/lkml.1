Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbXEILH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbXEILH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbXEILHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:07:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbXEILHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:07:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070509034135.853ae84c.akpm@linux-foundation.org> 
References: <20070509034135.853ae84c.akpm@linux-foundation.org>  <20070508170051.eb4751ce.akpm@linux-foundation.org> <20070508194358.27477.74888.stgit@warthog.cambridge.redhat.com> <20070508194411.27477.7552.stgit@warthog.cambridge.redhat.com> <997.1178706347@redhat.com> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] AFS: Implement basic file write support 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 09 May 2007 12:07:39 +0100
Message-ID: <4815.1178708859@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> set_page_dirty() will set I_DIRTY_PAGES only.  ie: the inode has dirty
> pagecache data.
> 
> To tell the VFS that the inode itself is dirty one needs to run
> mark_inode_dirty().

But what's the difference in this case?  I don't need to write the inode back
per se, and the inode attributes can be updated by the mechanism of data
storage.

David
