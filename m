Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYKLQ60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYKLQ60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYKLQ6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:58:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57411 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751437AbYKLQ6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:58:16 -0500
Date: Wed, 12 Nov 2008 16:56:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, viro@zeniv.linux.org.uk,
       arjan@infradead.org, greg@kroah.com, tytso@mit.edu,
       akpm@linux-foundation.org
Subject: Re: [PATCH =-v3 07/21] fanotify: fastpath to ignore certain in core
 inodes
Message-ID: <20081112165638.54c38c5c@lxorguk.ukuu.org.uk>
In-Reply-To: <20081112165055.GB19669@infradead.org>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
	<20081112161103.25434.30104.stgit@paris.rdu.redhat.com>
	<20081112165055.GB19669@infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 11:50:55 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Nov 12, 2008 at 11:11:03AM -0500, Eric Paris wrote:
> > Allows a process to ignore certain events for the given in core inodes.
> > This does not preclude the need to keep a userspace or xattr based
> > cache if a fanotifier listener wants something with a different lifetime
> > than in core inode.
> 
> Please just do this in userspace instead of bloating the inode.

Sounds a good way of ruining the performance.

Alan
