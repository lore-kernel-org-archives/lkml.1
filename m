Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbYEGCJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbYEGCJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 22:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbYEGCJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 22:09:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbYEGCJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 22:09:17 -0400
Date: Tue, 6 May 2008 19:08:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: "Paul Menage" <menage@google.com>, lizf@cn.fujitsu.com,
       seto.hidetoshi@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
Message-Id: <20080506190809.df1b9398.akpm@linux-foundation.org>
In-Reply-To: <20080506205852.8adaa0a2.pj@sgi.com>
References: <48210101.1070205@google.com>
	<20080506183841.e1771032.akpm@linux-foundation.org>
	<482109E5.5050204@cn.fujitsu.com>
	<20080506204946.7754302d.pj@sgi.com>
	<6599ad830805061851n767ff7a1qc8cb850ec98ad60d@mail.gmail.com>
	<20080506205852.8adaa0a2.pj@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 20:58:52 -0500 Paul Jackson <pj@sgi.com> wrote:

> Paul M wrote:
> > I was just trying to get close to the original behaviour.
> 
> An honorable goal.
> 
> Li Zefan - would you be interested in generating a patch
> that fails -EINVAL for inputs outside the range of [-1 ... N]
> for whatever small positive N the kernel recognizes?

I'd like to get Paul's patch into mainline this evening, to give us a
chance to get the subsequent mess sorted out in time for next
linux-next[*].  So there's no rush on this update.

[*] Judging by this:

kernel/cpuset.c: In function 'cpuset_common_file_write':
kernel/cpuset.c:1374: warning: passing argument 3 of 'update_flag' makes integer from pointer without a cast
kernel/cpuset.c: In function 'cpuset_destroy':
kernel/cpuset.c:1793: warning: passing argument 3 of 'update_flag' makes integer from pointer without a cast

Paul should drop sched-devel.  I'm suspecting it contains stale old stuff
which wasn't supposed to be there.

