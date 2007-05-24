Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbXEXS6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbXEXS6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbXEXS6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:58:43 -0400
Received: from web36615.mail.mud.yahoo.com ([209.191.85.32]:24537 "HELO
	web36615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750813AbXEXS6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:58:42 -0400
X-YMail-OSG: EX16qr4VM1nIrhl6pCaJ3gQf0s0uFWiwGms9izLeD0stPKUIS2bSYoDj5ThC_KRuhfDHdk0viw--
X-RocketYMMF: rancidfat
Date: Thu, 24 May 2007 11:58:41 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
To: Andreas Gruenbacher <agruen@suse.de>, James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <200705242010.00961.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <309300.41401.qm@web36615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andreas Gruenbacher <agruen@suse.de> wrote:

> > where the objects referenced by the paths are identical and visible to the
> > subject along both paths, in keeping with your description of "policy may
> > allow access to some locations but not to others" ?
> 
> I'm not aware of situations where giving different permissions to different  
> paths to the same file would actually be useful. The security model doesn't  
> prevent it though, and it's not a security hole.

On Fedora zcat, gzip and gunzip are all links to the same file.
I can imagine (although it is a bit of a stretch) allowing a set
of users access to gunzip but not gzip (or the other way around).
There are probably more sophisticated programs that have different
behavior based on the name they're invoked by that would provide
a more compelling arguement, assuming of course that you buy into
the behavior-based-on-name scheme. What I think I'm suggesting is
that AppArmor might be useful in addressing the fact that a file
with multiple hard links is necessarily constrained to have the
same access control on each of those names. That assumes one
believes that such behavior is flawwed, and I'm not going to try
to argue that. The question was about an example, and there is one.



Casey Schaufler
casey@schaufler-ca.com
