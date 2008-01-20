Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbYATDhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbYATDhv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 22:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYATDhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 22:37:43 -0500
Received: from jbanks.dsl.xmission.com ([204.228.152.159]:59422 "EHLO
	mail.bakbone.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751537AbYATDhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 22:37:42 -0500
From: Justin Banks <justinb@bakbone.com>
Date: Sat, 19 Jan 2008 20:31:46 -0700
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Justin Banks <justinb@bakbone.com>, linux-kernel@vger.kernel.org
Subject: Re: Where's the create() pointer?
Message-ID: <20080120033146.GA6744@bleen.domain.actdsltmp>
References: <20080119150718.GA14765@bleen.domain.actdsltmp> <1200759175.8028.6.camel@heimdal.trondhjem.org> <20080119190249.GA4383@bleen.domain.actdsltmp> <1200773162.9095.11.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200773162.9095.11.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote
> 
> On Sat, 2008-01-19 at 12:02 -0700, Justin Banks wrote:
> > Trond Myklebust wrote
> > > 
> > > On Sat, 2008-01-19 at 08:07 -0700, Justin Banks wrote:
> > > > It's probably been this way for a long time, and I'm just noticing, but
> > > > I can't seem to find the create() (among others) pointer for NFS filesystems.
> > > > 
> > > > Specifically, If I look at sb->s_root->d_inode->i_op there's no create
> > > > there. How do I find it? I'm guessing that the ability to share mount
> > > > structures between multiple NFS mounts resulted in some kind of fake
> > > > superblock, but I just can't figure out where to find the functions.
> > > 
> > > Why would you want to do this in the first place?
> > 
> > I'm just looking at trapping new creates on NFS, and so I need to find
> > the pointer.
> 
> What is your purpose in trapping creates on the client? Is this for
> accounting purposes? If so, why wouldn't inotify, or even a systemtap
> script suffice?

Could do inotify, except on a large-ish filesystem, it's really
unuseable, if you want to track everything that's going on.

> Anyhow, the simplest way to find the pointer is to grep for nfs_create
> in /proc/kallsyms.

Ugh. That's an ugly way, seems to me. Isn't there a way, given the
superblock? I mean, the VFS does it that way, doesn't it?

-justinb

-- 
Justin Banks
BakBone Software
justinb@bakbone.com
