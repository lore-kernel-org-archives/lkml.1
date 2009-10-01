Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbZJAKmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbZJAKmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbZJAKmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:42:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58843 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbZJAKmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:42:10 -0400
Date: Thu, 1 Oct 2009 12:42:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andy Spencer <andy753421@gmail.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Privilege dropping security module
Message-ID: <20091001104208.GC2159@elf.ucw.cz>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net> <4ABA892A.9090804@schaufler-ca.com> <20090923223110.GA1449@c.hsd1.tn.comcast.net> <20091001073853.GA1330@ucw.cz> <20091001091537.GA22337@c.hsd1.tn.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001091537.GA22337@c.hsd1.tn.comcast.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-10-01 09:15:37, Andy Spencer wrote:
> > Yeah, and now your ~/.ssh/identity is being uploaded to remote server.
> 
> The given policy sets the home directory (including ~/.ssh/) to `X'
> which does not include read access, so ~/.ssh/identity should be safe.
> There are some other problems with this particular policy though, /tmp/
> is still readable for example.
> 
> 
> > I believe people are already sandboxing apps with selinux...
> 
> Yes, some people (including myself) are already using selinux, tomoyo,
> smack, etc, for sandboxing. However, I think those have some
> disadvantages that I'm trying to address.

Ok, I guess advantages over selinux (etc) are probably worth it for
changelog on submission...

> > ...and subterfugue certainly does what you want, using ptrace... no
> > kernel mods needed and should already be secure.
> 
> subterfugue does look interesting, but it seems like it would be pretty
> slow and hasn't been unmaintained since 2001.

It is userland code, it should not have rotted that much.
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
