Return-Path: <linux-kernel-owner+w=401wt.eu-S941435AbXHJQRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941435AbXHJQRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940634AbXHJQH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:07:59 -0400
Received: from pat.uio.no ([129.240.10.15]:47068 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940140AbXHJQHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:07:54 -0400
Subject: Re: [PATCH 14/14] NFS: Use local caching [try #2]
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
In-Reply-To: <24071.1186754680@redhat.com>
References: <1186687557.6699.167.camel@heimdal.trondhjem.org>
	 <1186683869.6699.136.camel@heimdal.trondhjem.org>
	 <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com>
	 <20070809160550.17906.40862.stgit@warthog.cambridge.redhat.com>
	 <21984.1186685548@redhat.com>  <24071.1186754680@redhat.com>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 12:07:45 -0400
Message-Id: <1186762065.6642.5.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.103)
X-UiO-Scanned: 93B4DA415E86735FE023D98499EA2A2D27E60B6A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 65 total 3190139 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-10 at 15:04 +0100, David Howells wrote:
> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > > > Dang, that's a lot of inlines... AFAICS, approx half of fs/nfs/fscache.h
> > > > should really be moved into fscache.c.
> > > 
> > > If you wish.  It seems a shame since a lot of them have only one caller.
> > 
> > ...however it also forces you to export a lot of stuff which is really
> > private to fscache.c (the atomics etc).
> 
> The atomics is actually a bad example.  These are referred to directly by part
> of the table in fs/nfs/sysctl.c.  Is there a better way of exporting
> statistics than through /proc/sys/ files?

/proc/self/mountstats

Trond

