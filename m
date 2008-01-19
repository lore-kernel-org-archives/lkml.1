Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbYASTI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbYASTI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 14:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYASTIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 14:08:47 -0500
Received: from jbanks.dsl.xmission.com ([204.228.152.159]:53188 "EHLO
	mail.bakbone.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751270AbYASTIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 14:08:46 -0500
From: Justin Banks <justinb@bakbone.com>
Date: Sat, 19 Jan 2008 12:02:49 -0700
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Justin Banks <justinb@bakbone.com>, linux-kernel@vger.kernel.org
Subject: Re: Where's the create() pointer?
Message-ID: <20080119190249.GA4383@bleen.domain.actdsltmp>
References: <20080119150718.GA14765@bleen.domain.actdsltmp> <1200759175.8028.6.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200759175.8028.6.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote
> 
> On Sat, 2008-01-19 at 08:07 -0700, Justin Banks wrote:
> > It's probably been this way for a long time, and I'm just noticing, but
> > I can't seem to find the create() (among others) pointer for NFS filesystems.
> > 
> > Specifically, If I look at sb->s_root->d_inode->i_op there's no create
> > there. How do I find it? I'm guessing that the ability to share mount
> > structures between multiple NFS mounts resulted in some kind of fake
> > superblock, but I just can't figure out where to find the functions.
> 
> Why would you want to do this in the first place?

I'm just looking at trapping new creates on NFS, and so I need to find
the pointer.

> Anyhow, to answer the question: sb->s_root is not guaranteed to be a
> real file on NFS. The real mountpoints are usually in the anonymous
> dentry list.

Okay, I'll look there, thanks.

-justinb

-- 
Justin Banks
BakBone Software
justinb@bakbone.com
