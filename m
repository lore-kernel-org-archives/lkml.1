Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbZDQB0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbZDQB0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbZDQBZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:25:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55348 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbZDQBZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:25:55 -0400
Date: Fri, 17 Apr 2009 10:24:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] io-throttle documentation
Message-Id: <20090417102417.88a0ef93.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1239740480-28125-2-git-send-email-righi.andrea@gmail.com>
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com>
	<1239740480-28125-2-git-send-email-righi.andrea@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 22:21:12 +0200
Andrea Righi <righi.andrea@gmail.com> wrote:

> +Example:
> +* Create an association between an io-throttle group and a bio-cgroup group
> +  with "bio" and "blockio" subsystems mounted in different mount points:
> +  # mount -t cgroup -o bio bio-cgroup /mnt/bio-cgroup/
> +  # cd /mnt/bio-cgroup/
> +  # mkdir bio-grp
> +  # cat bio-grp/bio.id
> +  1
> +  # mount -t cgroup -o blockio blockio /mnt/io-throttle
> +  # cd /mnt/io-throttle
> +  # mkdir foo
> +  # echo 1 > foo/blockio.bio_id

Why do we need multiple cgroups at once to track I/O ?
Seems complicated to me.

Thanks,
-Kame

