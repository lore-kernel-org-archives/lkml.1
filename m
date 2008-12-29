Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbYL2EC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbYL2EC0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 23:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbYL2ECP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 23:02:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307AbYL2ECO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 23:02:14 -0500
Date: Sun, 28 Dec 2008 20:01:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, Bernd Schubert <bernd.schubert@fastmail.fm>,
       nfsv4@linux-nfs.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       steved@redhat.com, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com,
       linux-next@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: Pull request for FS-Cache, including NFS patches
Message-Id: <20081228200134.426bf203.akpm@linux-foundation.org>
In-Reply-To: <20081229144533.4a0ab696.sfr@canb.auug.org.au>
References: <8930.1229560221@redhat.com>
	<20081218142420.GA16728@infradead.org>
	<20081218123601.11810b7f.akpm@linux-foundation.org>
	<200812190007.34581.bernd.schubert@fastmail.fm>
	<20081218152616.a24c013f.akpm@linux-foundation.org>
	<20081219110539.7e7e230c.sfr@canb.auug.org.au>
	<20081229144533.4a0ab696.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008 14:45:33 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi David,
> 
> On Fri, 19 Dec 2008 11:05:39 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Given the ongoing discussions around FS-Cache, I have removed it from
> > linux-next.  Please ask me to include it again (if sensible) once some
> > decision has been reached about its future.
> 
> What was the result of discussions around FS-Cache?

There was none.

Dan Muntz's question:

  Solaris has had CacheFS since ~1995, HPUX had a port of it since
  ~1997.  I'd be interested in evidence of even a small fraction of
  Solaris and/or HPUX shops using CacheFS.  I am aware of customers who
  thought it sounded like a good idea, but ended up ditching it for
  various reasons (e.g., CacheFS just adds overhead if you almost
  always hit your local mem cache).

was an very very good one.

Seems that instead of answering it, we've decided to investigate the
fate of those who do not learn from history.

>  I ask because it
> reappeared in linux-next today via the nfs tree (merged into that on Dec
> 24 and 25) ...

oh.
