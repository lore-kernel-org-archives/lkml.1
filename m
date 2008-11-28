Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbYK1Ey7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbYK1Ey7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 23:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYK1Eyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 23:54:50 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50113 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYK1Eyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 23:54:49 -0500
Date: Fri, 28 Nov 2008 04:54:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, hch@infradead.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH -v3 5/8] fsnotify: unified filesystem notification
	backend
Message-ID: <20081128045446.GG28946@ZenIV.linux.org.uk>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com> <20081125172117.17115.4875.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125172117.17115.4875.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 12:21:18PM -0500, Eric Paris wrote:

What the hell is ->notification_list and what in this patchset would
add stuff to it?  Even more interesting question: how long would these
guys remain there and what's to prevent a race with umount?  At least
'inode-only' events will pin down the inode and leaving the matching
iput() until after umount() is a Bad Thing(tm)...
