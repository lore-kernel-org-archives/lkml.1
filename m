Return-Path: <linux-kernel-owner+w=401wt.eu-S1765697AbYBVH0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765697AbYBVH0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 02:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762372AbYBVHZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 02:25:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53819 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbYBVHZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 02:25:57 -0500
Date: Fri, 22 Feb 2008 07:25:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: Tree for Feb 22
Message-ID: <20080222072554.GG27894@ZenIV.linux.org.uk>
References: <20080222170421.9e17d143.sfr@canb.auug.org.au> <20080222182116.b809022f.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222182116.b809022f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 06:21:16PM +1100, Stephen Rothwell wrote:
> On Fri, 22 Feb 2008 17:04:21 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Status of my local build tests is at
> > http://kisskb.ellerman.id.au/kisskb/branch/9/.  The sparc builds have
> > been mostly disabled while I obtain a working cross compiler.
> 
> I have reenabled the sparc and sparc64 builds but there is a bug in 32bit
> sparc (in Linus' tree) at the moment.

Remove includes of linux/rcupdate.h and linux/mm.h from memcontrol.h;
patch had been posted some time ago.
