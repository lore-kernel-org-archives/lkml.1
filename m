Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbYJUAOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbYJUAOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYJUAOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:14:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61222 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbYJUAOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:14:07 -0400
Message-ID: <48FD1EC7.1010201@cn.fujitsu.com>
Date: Tue, 21 Oct 2008 08:13:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/cgroup.c: remove unused variable
References: <20081020215601.GA21471@orion>
In-Reply-To: <20081020215601.GA21471@orion>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov wrote:
> 

I've sent a patch including this cleanup yesterday.

> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
> 
>  kernel/cgroup.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 046c160..ed21eb5 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2104,7 +2104,6 @@ static void *cgroup_tasks_start(struct seq_file *s, loff_t *pos)
>  	down_read(&cgrp->pids_mutex);
>  	if (pid) {
>  		int end = cgrp->pids_length;
> -		int i;
>  		while (index < end) {
>  			int mid = (index + end) / 2;
>  			if (cgrp->tasks_pids[mid] == pid) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
