Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbYFBJxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbYFBJxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYFBJxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:53:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58143 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbYFBJxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:53:18 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, hch@infradead.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@I-love.SAKURA.ne.jp, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
In-reply-to: <20080602093630.GA25254@infradead.org> (message from Christoph
	Hellwig on Mon, 2 Jun 2008 05:36:30 -0400)
Subject: Re: [patch 01/15] security: pass path to inode_create
References: <20080529134903.615127628@szeredi.hu> <20080529134958.655985182@szeredi.hu> <20080531083052.GH24135@infradead.org> <E1K2uXZ-0001eE-Oi@pomaz-ex.szeredi.hu> <20080602060144.GA11564@infradead.org> <E1K343a-0002dG-C9@pomaz-ex.szeredi.hu> <20080602091341.GA8011@infradead.org> <E1K36PE-0002wZ-0M@pomaz-ex.szeredi.hu> <20080602093630.GA25254@infradead.org>
Message-Id: <E1K36ii-0002zj-Gn@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 02 Jun 2008 11:52:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You act like a happy prince of VFS, but let me tell you one thing,
> > there's only one king in this kingdom of Linux, and that's Linus
> > Torvalds I.  And our wise king already said that apparmor can come, so
> > the question is not "if" but "how".
> > 
> > If you don't want to help, that's a pity, but of course I don't want
> > to (and can't) force you.  I can understand if personally you don't
> > think this is a good idea, and don't want to have anything to do with
> > it.  In that case I can leave you off the CC's for the parts which are
> > not just generic VFS cleanups but explicitly towards apparmor
> > integration.  Would that suit you?
> 
> No, 

So shall I leave you _on_ the CC's then?

> and Agenda doesn't make these patches any better.

Umm, what's wrong with the patches then?  What exactly do they break?
How do they make the kernel bigger and slower?  How do they make the
code less readable?

These patches fix several issues raised at previous submissions:

 - passing NULL vfsmounts
 - using nameidata
 - using extra stack for vfsmount argument

So, it seems to me that there's in fact no issues remaining and the
best excuse you can come up with is that it's a dumb idea.  Well,
that's not a very imressive technical argument IMNSHO.

Miklos
