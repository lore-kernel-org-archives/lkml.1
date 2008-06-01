Return-Path: <linux-kernel-owner+w=401wt.eu-S1751646AbYFAUxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbYFAUxL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 16:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYFAUwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 16:52:55 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56189 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbYFAUwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 16:52:54 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, jmorris@namei.org, sds@tycho.nsa.gov,
       eparis@redhat.com, casey@schaufler-ca.com, agruen@suse.de,
       jjohansen@suse.de, penguin-kernel@I-love.SAKURA.ne.jp,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
In-reply-to: <20080531083052.GH24135@infradead.org> (message from Christoph
	Hellwig on Sat, 31 May 2008 04:30:52 -0400)
Subject: Re: [patch 01/15] security: pass path to inode_create
References: <20080529134903.615127628@szeredi.hu> <20080529134958.655985182@szeredi.hu> <20080531083052.GH24135@infradead.org>
Message-Id: <E1K2uXZ-0001eE-Oi@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 01 Jun 2008 22:52:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > In the inode_create() security operation and related functions pass
> > the path (vfsmount + dentry) to the parent directory instead of the
> > inode.  AppArmor will need this.
> 
> So you're once again switching vfs_ to a pass a vfsmount argument, this
> time hidden under struct path.  It's really hard to grasp a "no"
> sometimes, isn't it? :)

I'm sorry Christoph, but have you considered the remote possibility,
that you and Al are both wrong on this one?  Well, there's one
excercise for you.

If you haven't noticed, I don't take "no" for an answer, until I'm
sufficiently convinced that there's a better way.  In this case I
haven't heard a solution, that is remotely close in cleanliness to
what I've proposed.  And also please note that "not merging apparmor"
is _not_ the answer, however much you would like that to be.  So
please try harder to find an alternative, and then I'll listen.

Miklos
