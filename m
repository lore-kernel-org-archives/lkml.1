Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbXDRERU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbXDRERU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbXDRERU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:17:20 -0400
Received: from smtp.osdl.org ([65.172.181.24]:46242 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbXDRERS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:17:18 -0400
Date: Tue, 17 Apr 2007 21:13:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: florin@iucha.net (Florin Iucha)
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-Id: <20070417211350.ebba1493.akpm@linux-foundation.org>
In-Reply-To: <20070418040730.GC24044@iucha.net>
References: <1176792399.3035.30.camel@twins>
	<20070416125905.GA2769@iucha.net>
	<1176792399.3035.30.camel@twins>
	<1176796503.3035.33.camel@twins>
	<87hcrfaqam.fsf@duaron.myhome.or.jp>
	<20070418011946.11679.34920.stgit@heimdal.trondhjem.org>
	<20070417195823.943f9472.akpm@linux-foundation.org>
	<1176865565.6796.16.camel@heimdal.trondhjem.org>
	<20070418033055.GA24044@iucha.net>
	<1176868485.6796.42.camel@heimdal.trondhjem.org>
	<20070418040730.GC24044@iucha.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007 23:07:30 -0500 florin@iucha.net (Florin Iucha) wrote:

> On Tue, Apr 17, 2007 at 11:54:45PM -0400, Trond Myklebust wrote:
> > > The good news is that the Gnome session log-in progresses to the point
> > > where both top and bottom bars are painted (gray) and the bottom bar
> > > is populated with icons (2.6.21-rc7 vanilla stops after displaying the
> > > splash).  The bad news is that it stops there.
> > > 
> > > Big-copy fails as well, after 2.5G transferred.
> > > 
> > > The process traces are at:
> > > 
> > >    http://iucha.net/nfs/21-rc7-nfs1/gnome-session
> > >    http://iucha.net/nfs/21-rc7-nfs1/big-copy
> > > 
> > > Regards,
> > > florin
> > 
> > Could you tell us a bit more about what happens when these hangs occur?
> > Does the networking stop too, or just NFS? How about CIFS?
> 
> The networking does not stop, I can ssh into and out of the box
> without any problem.
> 
> When 'gnome-session' hangs, it does not react to any clicks on the
> terminal or browser icons.  If I switch to a virtual console then come
> back into X, the panels (or splash) are gray - the icons disappear. I
> can switch to a virtual console and give it the three finger salute and
> it reboots cleanly.
> 
> When 'big-copy' hangs, if I switch to a different console and run
> 'lsof', '[u]mount', or use shell completion on a network mount then that
> process goes into D state.  I cannot umount the network shares nor
> stop autofs.  I cannot do a clean reboot, I have to ssh
> in and "echo s > /proc/sysrq-trigger; echo u > /proc/sysrq-trigger;
> echo b > /proc/sysrq-trigger" .

please, do `echo t > /proc/sysrq-trigger' first, send us the result.

