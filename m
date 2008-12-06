Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbYLFAUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbYLFAUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 19:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbYLFAUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 19:20:04 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:41310 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095AbYLFAUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 19:20:01 -0500
Date: Fri, 5 Dec 2008 18:19:57 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Linux Torvalds <torvalds@osdl.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       MinChan Kim <minchan.kim@gmail.com>, arnd@arndb.de, jeremy@goop.org
Subject: Re: [RFC v11][PATCH 00/13] Kernel based checkpoint/restart
Message-ID: <20081206001957.GA29851@us.ibm.com>
References: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> Checkpoint-restart (c/r): fixed races in file handling (comments from
> from Al Viro). Updated and tested against v2.6.28-rc7 (feaf384...)
> 
> We'd like these to make it into -mm. This version addresses the
> last of the known bugs. Please pull at least the first 11 patches,
> as they are similar to before.
> 
> Patches 1-11 are stable, providing self- and external- c/r of a
> single process.
> Patches 12 and 13 are newer, adding support for c/r of multiple
> processes.
> 
> The git tree tracking v11, branch 'ckpt-v11' (and older versions):
> 	git://git.ncl.cs.columbia.edu/pub/git/linux-cr.git
> 
> Restarting multiple processes requires 'mktree' userspace tool:
> 	git://git.ncl.cs.columbia.edu/pub/git/user-cr.git

Thanks Oren, this set is working great for me.  hours of
(run in container; while (1) { checkpoint; kill; restart in container;}
went fine.  500 simultaneoush checkpoints of the same task
went fine.  mktree works great.

thanks,
-serge
