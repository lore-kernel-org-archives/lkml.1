Return-Path: <linux-kernel-owner+w=401wt.eu-S965426AbXDGGmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965426AbXDGGmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 02:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965417AbXDGGmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 02:42:22 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:59301 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965410AbXDGGmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 02:42:21 -0400
To: akpm@linux-foundation.org
CC: linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
In-reply-to: <20070406160238.f3178189.akpm@linux-foundation.org> (message from
	Andrew Morton on Fri, 6 Apr 2007 16:02:38 -0700)
Subject: Re: [patch 0/8] unprivileged mount syscall
References: <20070404183012.429274832@szeredi.hu> <20070406160238.f3178189.akpm@linux-foundation.org>
Message-Id: <E1Ha4cN-0004rc-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 07 Apr 2007 08:41:48 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > This patchset adds support for keeping mount ownership information in
> > the kernel, and allow unprivileged mount(2) and umount(2) in certain
> > cases.
> 
> No replies, huh?

All we need is a comment from Andrew, and the replies come flooding in ;)

> My knowledge of the code which you're touching is not strong, and my spare
> reviewing capacity is not high.  And this work does need close review by
> people who are familar with the code which you're changing.
> 
> So could I suggest that you go for a dig through the git history, identify
> some individuals who look like they know this code, then do a resend,
> cc'ing those people?  Please also cc linux-kernel on that resend.

OK.

> > One thing that is missing from this series is the ability to restrict
> > user mounts to private namespaces.  The reason is that private
> > namespaces have still not gained the momentum and support needed for
> > painless user experience.  So such a feature would not yet get enough
> > attention and testing.  However adding such an optional restriction
> > can be done with minimal changes in the future, once private
> > namespaces have matured.
> 
> I suspect the people who developed and maintain nsproxy would disagree ;)

Well, they better show me some working and simple-to-use userspace
code, because I've not seen anything like that related to mount
namespaces.

pam_namespace.so is one example of a non-working, but probably-not-too-
hard-to-fix one.

I'm just saying this is not yet something that Joe Blow would just
enable by ticking a box in their desktop setup wizard, and it would
all work flawlessly thereafter.  There's still a _long_ way towards
that, and mostly in userspace.

Thanks,
Miklos
