Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbYK1KRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbYK1KRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 05:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYK1KQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 05:16:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40554 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYK1KQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 05:16:59 -0500
Date: Fri, 28 Nov 2008 05:16:56 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, hch@infradead.org,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH -v3 3/8] fsnotify: sys_execve and sys_uselib do not
	call into fsnotify
Message-ID: <20081128101656.GA20596@infradead.org>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com> <20081125172107.17115.98087.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125172107.17115.98087.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 12:21:07PM -0500, Eric Paris wrote:
> sys_execve and sys_uselib do not call into fsnotify so inotify, dnotify,
> and importantly to me fanotify do not see opens on things which are going
> to be exectued.  Create a generic fsnotify hook for these paths.

Can you please send these exec fixes in a separate series not depending
on any of the other stuff?

