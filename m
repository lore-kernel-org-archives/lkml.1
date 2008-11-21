Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbYKUINO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbYKUINO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYKUIM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:12:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262AbYKUIM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:12:56 -0500
Date: Fri, 21 Nov 2008 00:12:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/45] FS-Cache: Release page->private after failed
 readahead [ver #41]
Message-Id: <20081121001237.a26cbe8f.akpm@linux-foundation.org>
In-Reply-To: <20081120144205.10667.290.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
	<20081120144205.10667.290.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 14:42:05 +0000 David Howells <dhowells@redhat.com> wrote:

> +		if (TestSetPageLocked(page))

This got obsoleted by trylock_page().

I don't remember why, actually.
