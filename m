Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYAGIaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYAGIaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 03:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbYAGIaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 03:30:01 -0500
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2474 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbYAGIaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 03:30:00 -0500
Message-ID: <4781E301.7000502@xs4all.nl>
Date: Mon, 07 Jan 2008 09:29:53 +0100
From: Bauke Jan Douma <bjdouma@xs4all.nl>
Reply-To: bjdouma@xs4all.nl
Organization: a training zoo
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: umount -l <path>, getcwd and /proc/<pid>/cwd inconsistent
References: <1199675850.3156.15.camel@raven.themaw.net>
In-Reply-To: <1199675850.3156.15.camel@raven.themaw.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent wrote on 07-01-08 04:17:
> Hi all,
> 
> Could someone please help me understand what's happening with, what
> looks like inconsistent behavior, between getpwd and procfs readlink.
> 
> Basically, from a bash shell, setting working directory to a mounted
> directory all is fine with "pwd" and "/proc/<pid>/cwd". Following a
> "umount - l" on the mount "pwd" continues to return the expected string
> but "/proc/<pid>/cwd" returns an empty string.
> 
> What I'm really after is why this happens because sys_getcwd and
> proc_pid_readlink appear to do essentially the same thing to get the
> string.
> 
[snip]

What does `/bin/pwd' return, when you do that instead of
plain `pwd' (after the umount)?

bjd


