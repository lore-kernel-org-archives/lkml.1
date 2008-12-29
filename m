Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbYL2EIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbYL2EIP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 23:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYL2EH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 23:07:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbYL2EH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 23:07:56 -0500
Date: Sun, 28 Dec 2008 20:07:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, Bernd Schubert <bernd.schubert@fastmail.fm>,
       nfsv4@linux-nfs.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       steved@redhat.com, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com,
       linux-next@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: Pull request for FS-Cache, including NFS patches
Message-Id: <20081228200726.7b7078b4.akpm@linux-foundation.org>
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

> I ask because it
> reappeared in linux-next today via the nfs tree (merged into that on Dec
> 24 and 25) ...

And that of course means that many many 2.6.28 patches which I am
maintaining will need significant rework to apply on top of linux-next,
and then they won't apply to mainline.  Or that linux-next will not apply
on top of those patches.  Mainly memory management.

Please drop the NFS tree until after -rc1.

Guys, this: http://lkml.org/lkml/2008/12/27/173
