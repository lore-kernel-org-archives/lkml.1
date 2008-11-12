Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYKLQ4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYKLQ4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYKLQ4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:56:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33833 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYKLQ4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:56:14 -0500
Date: Wed, 12 Nov 2008 11:56:10 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Subject: Re: [PATCH =-v3 18/21] fanotify: all userspace to set timeouts
Message-ID: <20081112165610.GD19669@infradead.org>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com> <20081112161201.25434.80001.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112161201.25434.80001.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 11:12:01AM -0500, Eric Paris wrote:
> fanotify when used to make access decisions has a default 5 second timeout.
> This patch will allow userspace listeners to change their timeout on a
> group wide basis.  Userspace listeners will still be able to reset the
> timeout for individual events.

Really, I think you start to over-engineer.  I think this whole stuff
would have a much higher chance if you could come up with a staged set
of patchsets, ala:

 (1) unify the current *notify schemes
 (2) add a filesystem wide notify scheme
 (3) add blocking filesystem notifiers

and then maybe a fourth with all the misc little things that I doubt
will have much of a chance.

