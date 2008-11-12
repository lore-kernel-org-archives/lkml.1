Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbYKLQv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbYKLQv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYKLQu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:50:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47971 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYKLQu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:50:58 -0500
Date: Wed, 12 Nov 2008 11:50:55 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Subject: Re: [PATCH =-v3 07/21] fanotify: fastpath to ignore certain in
	core inodes
Message-ID: <20081112165055.GB19669@infradead.org>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com> <20081112161103.25434.30104.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112161103.25434.30104.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 11:11:03AM -0500, Eric Paris wrote:
> Allows a process to ignore certain events for the given in core inodes.
> This does not preclude the need to keep a userspace or xattr based
> cache if a fanotifier listener wants something with a different lifetime
> than in core inode.

Please just do this in userspace instead of bloating the inode.

