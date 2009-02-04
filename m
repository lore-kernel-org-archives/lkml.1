Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657AbZBDBKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbZBDBKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbZBDBKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:10:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58321 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbZBDBK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:10:29 -0500
Message-ID: <4988EADB.4050508@cn.fujitsu.com>
Date: Wed, 04 Feb 2009 09:09:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, rdunlap@xenotime.net
Subject: Re: [PATCH] trivial: fix where cgroup documentation is not correctly
 referred to
References: <498879F1.9040009@xenotime.net> <1233694085-23893-1-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1233694085-23893-1-git-send-email-cascardo@holoscopio.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thadeu Lima de Souza Cascardo wrote:
> cgroup documentation was moved to Documentation/cgroups/. There are some
> places that still refer to Documentation/controllers/,
> Documentation/cgroups.txt and Documentation/cpusets.txt. Fix those.
> 

After grep, I think there's no wrong ref anymore.

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  Documentation/00-INDEX                         |    4 ++--
>  Documentation/cgroups/00-INDEX                 |   18 ++++++++++++++++++
>  Documentation/kernel-parameters.txt            |    4 ++--
>  Documentation/scheduler/sched-rt-group.txt     |    2 +-
>  Documentation/vm/numa_memory_policy.txt        |    3 ++-
>  Documentation/vm/page_migration                |    3 ++-
>  Documentation/x86/x86_64/fake-numa-for-cpusets |    5 +++--
>  include/linux/cgroup.h                         |    5 ++++-
>  init/Kconfig                                   |    2 +-
>  9 files changed, 35 insertions(+), 11 deletions(-)
>  create mode 100644 Documentation/cgroups/00-INDEX
