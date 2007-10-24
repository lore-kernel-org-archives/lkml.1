Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbXJXAUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbXJXAUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 20:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbXJXAUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 20:20:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:48802 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbXJXAUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 20:20:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=xNg8vn4cR0nQ50N9xt1hKsV1IrXPxUi/ot0DRCZbpqgZbZtznc+5A4EJ2L662EzB2
	nqkJRhI+m0DPvAcDYAydg==
Message-ID: <6599ad830710231719y1075e1dfl94c9ae9258239c98@mail.gmail.com>
Date: Tue, 23 Oct 2007 17:19:55 -0700
From: "Paul Menage" <menage@google.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH 9/12] cgroup: kill unused variable
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
In-Reply-To: <20071023223644.308971F81B4@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
	 <20071023223644.308971F81B4@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/07, Jeff Garzik <jeff@garzik.org> wrote:
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

Acked-by: Paul Menage <menage@google.com>

> ---
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 5987dcc..3fe21e1 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2402,7 +2402,6 @@ struct file_operations proc_cgroup_operations = {
>  static int proc_cgroupstats_show(struct seq_file *m, void *v)
>  {
>         int i;
> -       struct cgroupfs_root *root;
>
>         seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\n");
>         mutex_lock(&cgroup_mutex);
>
