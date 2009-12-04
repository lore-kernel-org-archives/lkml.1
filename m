Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbZLDPjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbZLDPjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 10:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbZLDPjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 10:39:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36218 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbZLDPjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 10:39:19 -0500
Date: Fri, 4 Dec 2009 10:39:25 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de
Subject: Re: [PATCH 1/5] fsnotify/vfsmount: add fsnotify fields to struct
	vfsmount
Message-ID: <20091204153925.GA17062@infradead.org>
References: <20091203055315.21918.83562.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203055315.21918.83562.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 12:53:15AM -0500, Eric Paris wrote:
> From: Andreas Gruenbacher <agruen@suse.de>
> 
> This patch adds the list and mask fields needed to support vfsmount marks.
> These are the same fields fsnotify needs on an inode.  They are not used,
> just declared and we note where the cleanup hook should be (the function is
> not yet defined)

What's the rationale for adding them?

