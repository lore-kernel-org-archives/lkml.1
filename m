Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbZLUQmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbZLUQmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbZLUQmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:42:50 -0500
Received: from cobra.newdream.net ([66.33.216.30]:49705 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070AbZLUQms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:42:48 -0500
Date: Mon, 21 Dec 2009 08:42:47 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Valdis.Kletnieks@vt.edu
cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Ceph distributed file system client for 2.6.33
In-Reply-To: <14397.1261200797@localhost>
Message-ID: <Pine.LNX.4.64.0912192058390.8993@cobra.newdream.net>
References: <Pine.LNX.4.64.0912071511470.32397@cobra.newdream.net>
 <Pine.LNX.4.64.0912181140370.26094@cobra.newdream.net> <14397.1261200797@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Dec 2009, Valdis.Kletnieks@vt.edu wrote:

> On Fri, 18 Dec 2009 12:54:02 PST, Sage Weil said:
> > I would still like to see ceph merged for 2.6.33.  It's certainly not 
> > production ready, but it would be greatly beneficial to be in mainline for 
> > the same reasons other file systems like btrfs and exofs were merged 
> > early.
> 
> Is the on-the-wire protocol believed to be correct, complete, and stable? How
> about any userspace APIs and on-disk formats? In other words..
> 
> > > The git tree includes the full patchset posted in October and incremental
> > > changes since then.  I've tried to cram in all the anticipated protocol
> > > changes, but the file system is still strictly EXPERIMENTAL and is marked
> 
> Anything left dangling on the changes?

The wire protocol is close.  There is a corner cases with MDS failure 
recovery that need attention, but it can be resolved in a backward 
compatible way.  I think a compat/incompat flags mechanism during the 
initial handshake might be appropriate to make changes easier going 
forward.  I don't anticipate any other changes there.

There are some as-yet unresolved interface and performance issues with the 
way the storage nodes interact with btrfs that have on disk format 
implications.  I hope to resolve those shortly.  Those of course do not 
impact the client code.

sage

