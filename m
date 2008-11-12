Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbYKLVRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbYKLVRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYKLVQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:16:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56663 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbYKLVQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:16:55 -0500
Subject: Re: [PATCH =-v3 04/21] fsnotify: sys_execve and sys_uselib do not
 call into fsnotify
From: Eric Paris <eparis@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
In-Reply-To: <20081112164921.GA19669@infradead.org>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
	 <20081112161047.25434.58147.stgit@paris.rdu.redhat.com>
	 <20081112164921.GA19669@infradead.org>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 16:15:52 -0500
Message-Id: <1226524552.3353.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-12 at 11:49 -0500, Christoph Hellwig wrote:
> On Wed, Nov 12, 2008 at 11:10:47AM -0500, Eric Paris wrote:
> > sys_execve and sys_uselib do not call into fsnotify so inotify, dnotify,
> > and importantly to me fanotify do not see opens on things which are going
> > to be exectued.  Create a generic fsnotify hook for these paths.
> 
> This should be submitted as a bugfix on it's own to the current
> codebase.

I'll look into this.


