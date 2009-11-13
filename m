Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbZKMXJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbZKMXJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbZKMXJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:09:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932474AbZKMXJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:09:28 -0500
Date: Fri, 13 Nov 2009 15:09:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH -tip 1/3] Pass mm->flags to binfmt core_dump for bitflag
 consistency
Message-Id: <20091113150904.56c15910.akpm@linux-foundation.org>
In-Reply-To: <20091113225226.15079.90813.stgit@harusame>
References: <20091113225226.15079.90813.stgit@harusame>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009 17:52:27 -0500
Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Pass mm->flags to binfmt core_dump for bitflag consistency.
> Since mm->flags bit flags is not protected by locks, it will be
> changed while dumping core. This patch copies mm->flags to a
> mm_flags local variable at the beginning of do_coredump() and
> use it while dumping. mm_flags also includes dump_filter which
> filters elf sections from core file in elf_core_dump().
> So, this patch also passes mm_flags to each binfmt->core_dump().

I can kind-of guess the answer, but it would be much more reliable if
we were to hear this from yourself:

  Why did you write this patch?  What problem is being observed?
