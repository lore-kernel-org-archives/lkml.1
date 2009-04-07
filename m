Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbZDGXMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbZDGXMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZDGXM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:12:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175AbZDGXM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:12:27 -0400
Date: Tue, 7 Apr 2009 16:05:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org
Subject: Re: [PATCH -V2 02/13] fsnotify: unified filesystem notification
 backend
Message-Id: <20090407160555.e5881481.akpm@linux-foundation.org>
In-Reply-To: <20090327200515.32007.53032.stgit@paris.rdu.redhat.com>
References: <20090327200508.32007.63278.stgit@paris.rdu.redhat.com>
	<20090327200515.32007.53032.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 16:05:15 -0400
Eric Paris <eparis@redhat.com> wrote:

> fsnotify paves the way for fanotify.

It'd kinda help if the changelog were to tell us what fanotify is.

google takes me to http://lwn.net/Articles/306804/.  It's not
immediately obvious how fanotify differs from the existing stuff
(perhaps after some enhancements), apart from having a different
userspace interface?

Generally speaking it'd be nice if we were to be given a better
understanding of where all this is leading and what we can expect to
see as a consequence of merging this patch series.  If it cleans up the
existing stuff then that's cool, and might be sufficient grounds for a
merge.  But it's a bit of a worry if it commits us to merging things
which aren't well understood yet.


>  people may not care for the original
> companies that pushed for TALPA, but fanotify was designed with flexibility in
> mind.  A first group that wants fanotify like interfaces is the readahead
> group.  So they can be profiling at boot time in order to dynamicly tune
> readahead to help with boot speed.  I've got other ideas how to use fanotify
> to speed up boot when dealing with encrypted mounts, but I'm not ready to say
> it yet since I don't know if my idea will work.

TALPA is virus scanning.  But that didn't make it onto your list of
potential applications of fanotify?

I'm inclined to merge this patch series if only to get us an
inotify/dnotify maintainer ;)


General comment on the patches: complex.  I found them depressingly
hard to understand (and hence review) - the lack of high-level
commentary in the code is pretty severe.  There's a nice-looking design
document there, but like everyone else, I didn't look at it much ;)
It's not really a successful substitute for carefully-chosen comments
at the appropriate codesites and data structures.
