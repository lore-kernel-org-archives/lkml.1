Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbYIODzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbYIODzw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 23:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbYIODzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 23:55:44 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17200 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbYIODzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 23:55:43 -0400
Date: Sun, 14 Sep 2008 20:55:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "S K" <nospamnoham@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Unable to find files in include/asm-arm in the Linus's tree
Message-Id: <20080914205538.27e7b1d4.randy.dunlap@oracle.com>
In-Reply-To: <514e099a0809141825u34015891pa3f11267373ae818@mail.gmail.com>
References: <514e099a0809141825u34015891pa3f11267373ae818@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Sep 2008 18:25:55 -0700 S K wrote:

> Hi,
> 
>   I think the copy paste of the terminal will explain it better:
> 
> $ git status
> # On branch master
> nothing to commit (working directory clean)
> 
> $ cat .git/config
> [core]
>         repositoryformatversion = 0
>         filemode = true
>         bare = false
>         logallrefupdates = true
> [remote "origin"]
>         url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>         fetch = +refs/heads/*:refs/remotes/origin/*
> [branch "master"]
>         remote = origin
>         merge = refs/heads/master
> 
> $ ls include/asm-arm/
> plat-s3c  plat-s3c24xx
> 
> Where are the other files? I'm totally confused. Doesn't Linus's tree
> have the code for all archs?
> 
> It obvious from the status I didn't delete them, but even a
> $ git reset --hard HEAD
> didn't help.

Hi,

Lots of arch-specific include/ directories were moved to arch/$ARCH/.
E.g., arch/arm/include/asm/ contains lots of files and a few sub-directories.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
