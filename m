Return-Path: <linux-kernel-owner+w=401wt.eu-S1759080AbYFBK4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbYFBK4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759291AbYFBKz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:55:56 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57759 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759033AbYFBKzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:55:54 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, hch@infradead.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
In-reply-to: <20080602104203.GA21898@infradead.org> (message from Christoph
	Hellwig on Mon, 2 Jun 2008 06:42:03 -0400)
Subject: Re: [patch 01/15] security: pass path to inode_create
References: <20080529134903.615127628@szeredi.hu> <20080529134958.655985182@szeredi.hu> <20080531083052.GH24135@infradead.org> <E1K2uXZ-0001eE-Oi@pomaz-ex.szeredi.hu> <20080602060144.GA11564@infradead.org> <E1K343a-0002dG-C9@pomaz-ex.szeredi.hu> <20080602091341.GA8011@infradead.org> <E1K36PE-0002wZ-0M@pomaz-ex.szeredi.hu> <20080602093630.GA25254@infradead.org> <E1K36ii-0002zj-Gn@pomaz-ex.szeredi.hu> <20080602104203.GA21898@infradead.org>
Message-Id: <E1K37hN-00039y-5o@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 02 Jun 2008 12:55:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > These patches fix several issues raised at previous submissions:
> > 
> >  - passing NULL vfsmounts
> >  - using nameidata
> >  - using extra stack for vfsmount argument
> > 
> > So, it seems to me that there's in fact no issues remaining and the
> > best excuse you can come up with is that it's a dumb idea.  Well,
> > that's not a very imressive technical argument IMNSHO.
> 
> Well, pathname based access control is a dumb idea, and we've been
> through this N times.

You think it's a dumb idea.  Several major distros, which ship the
code, *despite* being out-of-tree, don't.

> You've also been told that vfs_ routines should
> remain without vfsmount,

Oh, I've been told.  But valid technical reason given?  No.

Such hand waving won't help your cause at all.  It's time for you to
actually look at the patches and stat technical reasons why they are
wrong, or let them be included.  Is it so hard to understand that the
decision to include apparmor is not in your hands?

You can argue against the concept of apparmor itself, but you better
argue with Crispin, because I'm quite clueless about that part.  When
you've convinced him (and Linus (and Ubuntu, and SUSE, and Mandriva))
that apparmor is a stupid idea, then I'll give up.  Good luck with
that!

Miklos
