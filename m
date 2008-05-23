Return-Path: <linux-kernel-owner+w=401wt.eu-S1758983AbYEWSCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983AbYEWSCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 14:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYEWSCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 14:02:22 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37703 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbYEWSCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 14:02:21 -0400
To: zippel@linux-m68k.org
CC: miklos@szeredi.hu, hch@infradead.org, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.64.0805231824370.18302@localhost.localdomain>
	(message from Roman Zippel on Fri, 23 May 2008 18:30:57 +0200 (CEST))
Subject: Re: [patch 06/14] hfsplus: remove hfsplus_permission()
References: <20080521171458.077908538@szeredi.hu> <20080521171549.964767446@szeredi.hu>
 <Pine.LNX.4.64.0805212232500.18302@localhost.localdomain>
 <E1Jz5gq-0007F4-AQ@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221358080.18302@localhost.localdomain>
 <E1Jz9jk-0007rg-5W@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221427300.18302@localhost.localdomain>
 <E1JzA2r-0007uK-8L@pomaz-ex.szeredi.hu> <20080523092114.GD27119@infradead.org>
 <Pine.LNX.4.64.0805231712120.18302@localhost.localdomain>
 <E1JzZF5-0002Hz-5e@pomaz-ex.szeredi.hu> <E1JzZWC-0002M8-UP@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805231824370.18302@localhost.localdomain>
Message-Id: <E1Jzbai-0002d1-VC@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 23 May 2008 20:02:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And so I strongly suggest this patch as well.  Apparently this feature
> > is not even used by anybody, otherwise somebody would have noticed
> > when Trond's fix broke execute permission checking on regular files...
> 
> And I'm very strongly against this.
> If you wanted to rip out the resource inode logic, it would be more than 
> this.
> At worst this code does nothing right now, so why this sudden rush to 
> remove this without even an attempt of fixing it?

Because

 a) it's nontrivial to fix (even understanding the problem is
 nontrivial, see Documentation/filesystems/directory-locking)

 b) the feature is obviously unused, so the easiest fix is simply to
 remove it for the time being.

We generally don't leave code around which is known to be deadlockable
by unprivileged users.  Of course if you have a better fix, then
that's fine.

Miklos
