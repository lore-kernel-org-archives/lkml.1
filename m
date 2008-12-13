Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbYLMPaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbYLMPaG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 10:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbYLMP3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 10:29:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52871 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYLMP3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 10:29:55 -0500
Date: Sat, 13 Dec 2008 10:29:51 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       viro@ZenIV.linux.org.uk, hch@infradead.org, zbr@ioremap.net,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [RFC PATCH -v4 04/14] fsnotify: use the new open-exec hook for
	inotify and dnotify
Message-ID: <20081213152951.GA22802@infradead.org>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com> <20081212215135.27112.64080.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212215135.27112.64080.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 04:51:35PM -0500, Eric Paris wrote:
> inotify and dnotify did not get access events when their children were
> accessed for shlib or exec purposes.  Trigger on those events as well.

And requesting it about the third time:  Can you please submit this (and
the required previous patch) as a bug fix?  We'd like to have this in
ASAP even if the rest will need some more work.

