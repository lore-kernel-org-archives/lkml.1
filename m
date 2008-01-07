Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbYAGJaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbYAGJaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 04:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYAGJaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 04:30:05 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33349 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753068AbYAGJaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 04:30:02 -0500
X-Sasl-enc: Eblacs8wMzjx/TyzS35IlDguTRQak5453w4APMcjjhEo 1199698201
Subject: Re: umount -l <path>, getcwd and /proc/<pid>/cwd inconsistent
From: Ian Kent <raven@themaw.net>
To: bjdouma@xs4all.nl
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1199696154.3156.74.camel@raven.themaw.net>
References: <1199675850.3156.15.camel@raven.themaw.net>
	 <4781E301.7000502@xs4all.nl>  <1199696154.3156.74.camel@raven.themaw.net>
Content-Type: text/plain
Date: Mon, 07 Jan 2008 18:29:37 +0900
Message-Id: <1199698177.3156.79.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-07 at 17:55 +0900, Ian Kent wrote:
> On Mon, 2008-01-07 at 09:29 +0100, Bauke Jan Douma wrote:
> > Ian Kent wrote on 07-01-08 04:17:
> > > Hi all,
> > > 
> > > Could someone please help me understand what's happening with, what
> > > looks like inconsistent behavior, between getpwd and procfs readlink.
> > > 
> > > Basically, from a bash shell, setting working directory to a mounted
> > > directory all is fine with "pwd" and "/proc/<pid>/cwd". Following a
> > > "umount - l" on the mount "pwd" continues to return the expected string
> > > but "/proc/<pid>/cwd" returns an empty string.
> > > 
> > > What I'm really after is why this happens because sys_getcwd and
> > > proc_pid_readlink appear to do essentially the same thing to get the
> > > string.
> > > 
> > [snip]
> > 
> > What does `/bin/pwd' return, when you do that instead of
> > plain `pwd' (after the umount)?
> 
> I did check that at one point and it returned the same as pwd.
> I'll check again later, but I remember I explicitly checked that along
> the way.

Hey, I was sure I tested that.
It, in fact, returns nothing also.

Ian


