Return-Path: <linux-kernel-owner+w=401wt.eu-S1756976AbYFBP7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbYFBP7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYFBP7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:59:23 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:35325 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbYFBP7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:59:21 -0400
Date: Mon, 2 Jun 2008 19:51:52 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Toshiharu Harada <haradats@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@i-love.sakura.ne.jp, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 01/15] security: pass path to inode_create
Message-ID: <20080602155152.GA18257@2ka.mipt.ru>
References: <20080602060144.GA11564@infradead.org> <E1K343a-0002dG-C9@pomaz-ex.szeredi.hu> <20080602091341.GA8011@infradead.org> <E1K36PE-0002wZ-0M@pomaz-ex.szeredi.hu> <20080602093630.GA25254@infradead.org> <E1K36ii-0002zj-Gn@pomaz-ex.szeredi.hu> <20080602104203.GA21898@infradead.org> <E1K37hN-00039y-5o@pomaz-ex.szeredi.hu> <20080602150517.GB22400@2ka.mipt.ru> <9d732d950806020831h1b8aeabag9cb6db8e16bac971@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d732d950806020831h1b8aeabag9cb6db8e16bac971@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 12:31:14AM +0900, Toshiharu Harada (haradats@gmail.com) wrote:
> > This is a really interesting flame, can you proceed,
> > we will run for cola and peanuts :)
> 
> Let me quote a message by Chris Wright from LSM ml:
> "You cannot discover the path used to access an inode without knowing
> both the dentry and the vfsmount objects. "

Depending on what path you really want. If you want it related to bind
mount, you can (trivially). And even full path with vfsmount with
additional work.

Without any single additional patch on top of security system.

It maybe a bit slower, more complex, duplicate, whatever...
Active security was never a fast solution and was never a compromiss
between those who like it and who do not.

Technically you can be inside created limits and formally do not change
security model, but in practice implement you lovely path based security
checks.

> Another one by Stephen Smalley:
> "Pathname-based security considered harmful.  You want to control access
> to an object, not a name, and the name-to-object mapping is neither
> one-to-one nor immutable."

For those who care exactly about path, they do not want to have security
checks for object, which was there. As addition, selinux
maintainer/architector opinion is a bit biassed :)

> Can you guess when they were posted?
> The answer is December 2003. :)
> Do we need more time? I don't think so.

Apparently we do :)

> I'm viewing Miklos' patches as *enhancements* not only for AppArmor (and
> other pathname-based LSM modules). Everyone can make use of
> information and lose nothing.  Am I too simple minded?

What I wanted to say, is that people who do want to implement theirs
idea, will find a way to do it without breaking other approach.
With additional changes, with more complex approach, more code and
possibly some duplication/optimization/whatever.

So, if people continue to kick theirs head to the wall, they want
exactly that flame, that void talks and so on :)

-- 
	Evgeniy Polyakov
