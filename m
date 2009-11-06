Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbZKFNib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbZKFNib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 08:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997AbZKFNia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 08:38:30 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:50047 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460AbZKFNia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 08:38:30 -0500
Date: Fri, 6 Nov 2009 14:38:33 +0100
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Jody Belka <jody+lkml@jj79.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: OOM killer, page fault
Message-ID: <20091106133833.GA23151@gamma.logic.tuwien.ac.at>
References: <20091102135640.93de7c2a.minchan.kim@barrios-desktop> <28c262360911012300h4535118ewd65238c746b91a52@mail.gmail.com> <20091102155543.E60E.A69D9226@jp.fujitsu.com> <20091102140216.02567ff8.kamezawa.hiroyu@jp.fujitsu.com> <20091102141917.GJ2116@gamma.logic.tuwien.ac.at> <28c262360911020640k3f9dfcdct2cac6cc1d193144d@mail.gmail.com> <20091105132109.GA12676@gamma.logic.tuwien.ac.at> <loom.20091105T213323-393@post.gmane.org> <28c262360911051418r1aefbff6oa54a63d887c0ea48@mail.gmail.com> <20091106000113.GE22289@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091106000113.GE22289@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

On Fr, 06 Nov 2009, preining wrote:
> Recompiling already and trying to recreate the oom-killer boom.

Well, after rebooting into that kernel I get *loads*, every few seconds,
of warnings in the log. Hard to sort out what is real. Is that expected?

Excerpt from the log:
[ 2077.753841] vma->vm_ops->fault : 0xffffffff811df4bd
[ 2077.753842] ------------[ cut here ]------------
[ 2077.753845] WARNING: at mm/memory.c:2722 __do_fault+0x89/0x382()
[ 2077.753847] Hardware name: VGN-Z11VN_B
...
[ 2077.753880] Pid: 4892, comm: Xorg Tainted: G        W  2.6.32-rc6 #5
[ 2077.753881] Call Trace:
[ 2077.753884]  [<ffffffff8108c6cc>] ? __do_fault+0x89/0x382
[ 2077.753887]  [<ffffffff8108c6cc>] ? __do_fault+0x89/0x382
[ 2077.753889]  [<ffffffff8103ae54>] ? warn_slowpath_common+0x77/0xa3
[ 2077.753892]  [<ffffffff8108c6cc>] ? __do_fault+0x89/0x382
[ 2077.753895]  [<ffffffff81341a82>] ? _spin_unlock+0x23/0x2f
[ 2077.753898]  [<ffffffff8108e5d0>] ? handle_mm_fault+0x2b9/0x608
[ 2077.753900]  [<ffffffff810af792>] ? do_vfs_ioctl+0x443/0x47b
[ 2077.753903]  [<ffffffff81026759>] ? do_page_fault+0x25f/0x27b
[ 2077.753906]  [<ffffffff81341e8f>] ? page_fault+0x1f/0x30
[ 2077.753908] ---[ end trace d3324ef5061f0136 ]---

hundreds/thousands of them.

And even without starting anything else. Is that what you want?
My syslog file has grown to some hundred megabytes ...


Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining                                        Associate Professor
JAIST Japan Advanced Institute of Science and Technology   preining@jaist.ac.jp
Vienna University of Technology                               preining@logic.at
Debian Developer (Debian TeX Task Force)                    preining@debian.org
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
LARGOWARD (n.)
Motorists' name for the kind of pedestrian who stands beside a main
road and waves on the traffic, as if it's their right of way.
			--- Douglas Adams, The Meaning of Liff
