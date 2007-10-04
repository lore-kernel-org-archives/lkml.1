Return-Path: <linux-kernel-owner+w=401wt.eu-S1760932AbXJDUAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760932AbXJDUAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 16:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757830AbXJDUAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 16:00:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756658AbXJDUAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 16:00:21 -0400
Date: Thu, 4 Oct 2007 12:59:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: drzeus-list@drzeus.cx, staubach@redhat.com, nfsv4@linux-nfs.org,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [NFS] What's slated for inclusion in 2.6.24-rc1 from the NFS
 client git tree...
Message-Id: <20071004125916.dbe4fd13.akpm@linux-foundation.org>
In-Reply-To: <1191525363.6739.12.camel@heimdal.trondhjem.org>
References: <1191454876.6726.32.camel@heimdal.trondhjem.org>
	<20071004085206.0a8e37b5@poseidon.drzeus.cx>
	<1191506450.6685.17.camel@heimdal.trondhjem.org>
	<20071004184304.6e71ab6d@poseidon.drzeus.cx>
	<20071004114243.3161af16.akpm@linux-foundation.org>
	<1191525363.6739.12.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Oct 2007 15:16:03 -0400
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> > > 
> > > That would be perfect. It can even be in non-legacy mode by default,
> > > just as long as you can go back to the old behaviour when/if you run
> > > into a non-LFS application.
> > > 
> > 
> > Wouldn't a mount option be better?
> 
> I suppose that might be OK if you know that the 32-bit legacy
> applications will only touch one or two servers, but that sounds like a
> niche thing.
> 
> On the downside, forcing all those people who have portable 64-bit aware
> applications to upgrade their version of mount just in order to have
> stat64() work correctly seems unnecessarily complicated. I'd prefer not
> to have to do that unless someone comes up with a good reason why we
> must.

Confused.  You don't need to modify mount(8) when adding a new mount option?
