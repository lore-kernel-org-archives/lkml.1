Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbZDGXNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbZDGXNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756360AbZDGXMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:12:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756326AbZDGXMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:12:35 -0400
Date: Tue, 7 Apr 2009 16:06:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org
Subject: Re: [PATCH -V2 09/13] fsnotify: add correlations between events
Message-Id: <20090407160630.e478f3ee.akpm@linux-foundation.org>
In-Reply-To: <20090327200554.32007.91417.stgit@paris.rdu.redhat.com>
References: <20090327200508.32007.63278.stgit@paris.rdu.redhat.com>
	<20090327200554.32007.91417.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 16:05:54 -0400
Eric Paris <eparis@redhat.com> wrote:

> inotify sends userspace a correlation between events when they are related
> (aka when dentries are moved).  This adds that same support for all
> fsnotify events.
> 

So is this a new userspace-visible feature?

>
> ...
>
> +static atomic_t fsnotify_sync_cookie = ATOMIC_INIT(0);
> +
> +u32 fsnotify_get_cookie(void)
> +{
> +	return atomic_inc_return(&fsnotify_sync_cookie);
> +}
> +EXPORT_SYMBOL_GPL(fsnotify_get_cookie);

Please make a poilcy of documenting the global symbols.  Especially the
exported-to-modules symbols.  At least.

>
> ...
>

