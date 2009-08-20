Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZHTVOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZHTVOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZHTVOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:14:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754570AbZHTVOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:14:34 -0400
Date: Thu, 20 Aug 2009 14:13:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Menage <menage@google.com>
Cc: bblum@andrew.cmu.edu, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH 1/8] Revert commit
 8827c288feb7810185aa7c2e37537202fc709869
Message-Id: <20090820141349.9967b275.akpm@linux-foundation.org>
In-Reply-To: <20090818235812.22531.76212.stgit@menage.mtv.corp.google.com>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
	<20090818235812.22531.76212.stgit@menage.mtv.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009 16:58:12 -0700
Paul Menage <menage@google.com> wrote:

> Revert commit 8827c288feb7810185aa7c2e37537202fc709869
> 
> This is in preparation for some clashing cgroups changes that subsume
> the original commit's functionaliy.


Please don't refer to commits via their bare hash number.

This commit actually has a different hash in my tree:

commit 096b7fe012d66ed55e98bc8022405ede0cc80e96
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed Jul 29 15:04:04 2009 -0700
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Wed Jul 29 19:10:35 2009 -0700

    cgroups: fix pid namespace bug


And it will definitely have a different hash in linux-next, -stable,
distro trees, etc.

So the conventional way of referring to a commit within a changelog is


096b7fe012d66ed55e98bc8022405ede0cc80e96 ("cgroups: fix pid namespace bug")


