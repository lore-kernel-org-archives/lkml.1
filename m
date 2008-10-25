Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYJYR7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYJYR7h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 13:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbYJYR71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 13:59:27 -0400
Received: from xenotime.net ([72.52.64.118]:54525 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752219AbYJYR70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 13:59:26 -0400
X-Greylist: delayed 842 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Oct 2008 13:59:26 EDT
Date: Sat, 25 Oct 2008 10:45:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH]mm/oom_kill.c: cleanup kerneldoc of badness()
Message-Id: <20081025104511.374179b2.rdunlap@xenotime.net>
In-Reply-To: <200810260021.08146.qhfeng.kernel@gmail.com>
References: <200810260021.08146.qhfeng.kernel@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008 00:21:08 +0800 Qinghuang Feng wrote:

> Paramter @mem has been removed since v2.6.26, now delete it's comment.
> 
> Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 64e5b4b..460f90e 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -38,7 +38,6 @@ static DEFINE_SPINLOCK(zone_scan_mutex);
>   * badness - calculate a numeric value for how bad this task has been
>   * @p: task struct of which task we should calculate
>   * @uptime: current uptime in seconds
> - * @mem: target memory controller
>   *
>   * The formula used is relatively simple and documented inline in the
>   * function. The main rationale is that we want to select a good task
