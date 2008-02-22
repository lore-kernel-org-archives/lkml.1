Return-Path: <linux-kernel-owner+w=401wt.eu-S1763319AbYBVH3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763319AbYBVH3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 02:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYBVH3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 02:29:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56003
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbYBVH3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 02:29:38 -0500
Date: Thu, 21 Feb 2008 23:30:15 -0800 (PST)
Message-Id: <20080221.233015.193695196.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Feb 22
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080222072554.GG27894@ZenIV.linux.org.uk>
References: <20080222170421.9e17d143.sfr@canb.auug.org.au>
	<20080222182116.b809022f.sfr@canb.auug.org.au>
	<20080222072554.GG27894@ZenIV.linux.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Fri, 22 Feb 2008 07:25:54 +0000

> On Fri, Feb 22, 2008 at 06:21:16PM +1100, Stephen Rothwell wrote:
> > On Fri, 22 Feb 2008 17:04:21 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > Status of my local build tests is at
> > > http://kisskb.ellerman.id.au/kisskb/branch/9/.  The sparc builds have
> > > been mostly disabled while I obtain a working cross compiler.
> > 
> > I have reenabled the sparc and sparc64 builds but there is a bug in 32bit
> > sparc (in Linus' tree) at the moment.
> 
> Remove includes of linux/rcupdate.h and linux/mm.h from memcontrol.h;
> patch had been posted some time ago.

Yes, it's clogged up in Andrew's patch queue somewhere.
