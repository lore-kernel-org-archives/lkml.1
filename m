Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab0BEJ0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 04:26:39 -0500
Received: from cantor.suse.de ([195.135.220.2]:46256 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835Ab0BEJ0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 04:26:37 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.33-rc6 - BUG at drivers/cpufreq/cpufreq.c:88
Date: Fri, 5 Feb 2010 10:26:32 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32.1-0.0.14.f17927a-desktop; KDE/4.3.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <6843.1265299202@localhost>
In-Reply-To: <6843.1265299202@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201002051026.33057.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 February 2010 17:00:02 Valdis.Kletnieks@vt.edu wrote:
> Hit this one again while setting up to bisect another issue.  I've verified
> that the fix *is* someplace in 2.6.33-rc6-mmotm0201 (as that one lives at least
> all the way to single-user mode), so I'm basically asking that somebody find
> the commit that fixes it and make sure it gets into 2.6.33-final.  I'd offer
> the commit number for the fix, but I'm hoping somebody recognizes it and pushes
> it so I don't have bisect to find the fixing commit.
> 
> Thomas?  Did you have a fix for this that hasn't been pulled by Linus yet?
The fix is to remove the patch.

> Refresher:  The bad commit was:
> 
> commit 46aeb7430f79cb4d03e17fedd6399884ab3aa697
> Author: Thomas Renninger <trenn@suse.de>
> Date:   Mon Dec 14 11:44:11 2009 +0100
> 
>     [CPUFREQ] Fix race in cpufreq_update_policy()
This one never hit Linus tree?
It was in -mm, but got reverted.

Did you bisect on another tree?

      Thomas


PS: I checked by:
> cat .git/FETCH_HEAD
fc76be434d90bcd57a0ea6b93a2e66a3fec4b664                branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
> git pull
Already up-to-date.
> git branch
* master
> git show 46aeb7430f79cb4d03e17fedd6399884ab3aa697
fatal: bad object 46aeb7430f79cb4d03e17fedd6399884ab3aa697
