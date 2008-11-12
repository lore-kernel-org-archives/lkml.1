Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbYKLQtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbYKLQtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYKLQt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:49:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47950 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbYKLQt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:49:27 -0500
Date: Wed, 12 Nov 2008 11:49:21 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Subject: Re: [PATCH =-v3 04/21] fsnotify: sys_execve and sys_uselib do not
	call into fsnotify
Message-ID: <20081112164921.GA19669@infradead.org>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com> <20081112161047.25434.58147.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112161047.25434.58147.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 11:10:47AM -0500, Eric Paris wrote:
> sys_execve and sys_uselib do not call into fsnotify so inotify, dnotify,
> and importantly to me fanotify do not see opens on things which are going
> to be exectued.  Create a generic fsnotify hook for these paths.

This should be submitted as a bugfix on it's own to the current
codebase.
