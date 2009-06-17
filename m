Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbZFQAoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbZFQAoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 20:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZFQAoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 20:44:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64644 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbZFQAn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 20:43:59 -0400
Message-ID: <4A383CAB.6060809@cn.fujitsu.com>
Date: Wed, 17 Jun 2009 08:45:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nikanth Karthikesan <knikanth@suse.de>
CC: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org
Subject: Re: cpusets: document adding/removing cpus to cpuset elaborately
References: <200906161646.50305.knikanth@suse.de>
In-Reply-To: <200906161646.50305.knikanth@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikanth Karthikesan wrote:
> Writing a pid to the file, tasks adds that task to that cgroup/cpuset. But to
> add a cpu/mem to a cpuset, the new list of cpus should be written to the
> cpuset.mems file which would replace the old list of cpus. Make this clearer
> in the documentation.
> 

Though I think '>' already means overwrite so removing/adding cpus should
always writing the full list of CPUs to 'cpus', more documentation to make
cpuset usage clearer is not bad.

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> ---
> 
> diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
> index f9ca389..1d7e978 100644
> --- a/Documentation/cgroups/cpusets.txt
> +++ b/Documentation/cgroups/cpusets.txt
> @@ -777,6 +777,18 @@ in cpuset directories:
>  # /bin/echo 1-4 > cpus		-> set cpus list to cpus 1,2,3,4
>  # /bin/echo 1,2,3,4 > cpus	-> set cpus list to cpus 1,2,3,4
>  
> +To add a CPU to a cpuset, write the new list of CPUs including the
> +CPU to be added. To add 6 to the above cpuset:
> +
> +# /bin/echo 1-4,6 > cpus	-> set cpus list to cpus 1,2,3,4,6
> +
> +Similarly to remove a CPU from a cpuset, write the new list of CPUs
> +without the CPU to be removed.
> +
> +To remove all the CPUs:
> +
> +# /bin/echo "" > cpus		-> clear cpus list
> +
>  2.3 Setting flags
>  -----------------
>  
