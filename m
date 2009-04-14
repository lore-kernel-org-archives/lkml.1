Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbZDNKAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbZDNKAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbZDNKAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:00:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43620 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028AbZDNKAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:00:32 -0400
Date: Tue, 14 Apr 2009 12:00:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/3] kill-the-BKL/reiserfs: reiserfs fixes
Message-ID: <20090414100013.GE3558@elte.hu>
References: <1239680065-25013-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239680065-25013-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> This small patchset fixes some deadlocks I've faced after trying 
> some pressures with dbench on a reiserfs partition.
> 
> There is still some work pending such as adding some checks to 
> ensure we _always_ release the lock before sleeping, as you 
> suggested. Also I have to fix a lockdep warning reported by 
> Alessio Igor Bogani. And also some optimizations....
> 
> Thanks,
> Frederic.
> 
> Frederic Weisbecker (3):
>   kill-the-BKL/reiserfs: provide a tool to lock only once the write lock
>   kill-the-BKL/reiserfs: lock only once in reiserfs_truncate_file
>   kill-the-BKL/reiserfs: only acquire the write lock once in
>     reiserfs_dirty_inode
> 
>  fs/reiserfs/inode.c         |   10 +++++++---
>  fs/reiserfs/lock.c          |   26 ++++++++++++++++++++++++++
>  fs/reiserfs/super.c         |   15 +++++++++------
>  include/linux/reiserfs_fs.h |    2 ++
>  4 files changed, 44 insertions(+), 9 deletions(-)

Applied, thanks Frederic!

	Ingo
