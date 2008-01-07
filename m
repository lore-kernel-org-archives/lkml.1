Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbYAGI41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbYAGI41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 03:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbYAGI4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 03:56:19 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42219 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754762AbYAGI4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 03:56:18 -0500
X-Sasl-enc: /jl8eEhith4f5+fR/jzxIcQJLocjTk4GARWBS5fi5Uys 1199696177
Subject: Re: umount -l <path>, getcwd and /proc/<pid>/cwd inconsistent
From: Ian Kent <raven@themaw.net>
To: bjdouma@xs4all.nl
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4781E301.7000502@xs4all.nl>
References: <1199675850.3156.15.camel@raven.themaw.net>
	 <4781E301.7000502@xs4all.nl>
Content-Type: text/plain
Date: Mon, 07 Jan 2008 17:55:54 +0900
Message-Id: <1199696154.3156.74.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-07 at 09:29 +0100, Bauke Jan Douma wrote:
> Ian Kent wrote on 07-01-08 04:17:
> > Hi all,
> > 
> > Could someone please help me understand what's happening with, what
> > looks like inconsistent behavior, between getpwd and procfs readlink.
> > 
> > Basically, from a bash shell, setting working directory to a mounted
> > directory all is fine with "pwd" and "/proc/<pid>/cwd". Following a
> > "umount - l" on the mount "pwd" continues to return the expected string
> > but "/proc/<pid>/cwd" returns an empty string.
> > 
> > What I'm really after is why this happens because sys_getcwd and
> > proc_pid_readlink appear to do essentially the same thing to get the
> > string.
> > 
> [snip]
> 
> What does `/bin/pwd' return, when you do that instead of
> plain `pwd' (after the umount)?

I did check that at one point and it returned the same as pwd.
I'll check again later, but I remember I explicitly checked that along
the way.

Ian


