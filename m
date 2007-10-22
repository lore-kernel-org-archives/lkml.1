Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbXJVWQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbXJVWQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbXJVWP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:15:59 -0400
Received: from smtp-out.google.com ([216.239.45.13]:14367 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbXJVWP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:15:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=xfKRKUhOC4KZku1DybtuFOh1YUyuD9ItTlJJN/B8+gtFjDfCeZSbNiyMSBpunMmfc
	/Y92DGHbB0GXVvDk3E7JQ==
Message-ID: <6599ad830710221515q89adbdg8fc1e3d6655ee951@mail.gmail.com>
Date: Mon, 22 Oct 2007 15:15:56 -0700
From: "Paul Menage" <menage@google.com>
To: "Dave Hansen" <haveblue@us.ibm.com>
Subject: Re: [PATCH] fix up cgroup warning
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071022221143.545A9EEC@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071022221143.545A9EEC@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks - this has already been sent to akpm.

Paul

On 10/22/07, Dave Hansen <haveblue@us.ibm.com> wrote:
>
> I just noticed this in mainline:
>
> kernel/cgroup.c: In function `proc_cgroupstats_show':
> kernel/cgroup.c:2405: warning: unused variable `root'
>
>
> ---
>
>  linux-2.6.git-dave/kernel/cgroup.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff -puN kernel/cgroup.c~cgroup-warning kernel/cgroup.c
> --- linux-2.6.git/kernel/cgroup.c~cgroup-warning        2007-10-22 15:10:20.000000000 -0700
> +++ linux-2.6.git-dave/kernel/cgroup.c  2007-10-22 15:10:20.000000000 -0700
> @@ -2402,7 +2402,6 @@ struct file_operations proc_cgroup_opera
>  static int proc_cgroupstats_show(struct seq_file *m, void *v)
>  {
>         int i;
> -       struct cgroupfs_root *root;
>
>         seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\n");
>         mutex_lock(&cgroup_mutex);
> diff -L +2405 -puN /dev/null /dev/null
> _
>
