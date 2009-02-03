Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZBCFyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZBCFyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbZBCFyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:54:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57746 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZBCFyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:54:12 -0500
Message-ID: <4987DBDF.9060504@cn.fujitsu.com>
Date: Tue, 03 Feb 2009 13:53:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] trivial: fix where cgroup documentation is not correctly
 referred to
References: <1233614324-27603-1-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1233614324-27603-1-git-send-email-cascardo@holoscopio.com>
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

Thanks! Could you also remove cpuset.txt from Documentation/00-INDEX and
add cgroups/ in it?

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  Documentation/kernel-parameters.txt            |    4 ++--
>  Documentation/scheduler/sched-rt-group.txt     |    2 +-
>  Documentation/vm/numa_memory_policy.txt        |    3 ++-
>  Documentation/vm/page_migration                |    3 ++-
>  Documentation/x86/x86_64/fake-numa-for-cpusets |    5 +++--
>  include/linux/cgroup.h                         |    5 ++++-
>  init/Kconfig                                   |    2 +-
>  7 files changed, 15 insertions(+), 9 deletions(-)
