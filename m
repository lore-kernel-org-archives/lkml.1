Return-Path: <linux-kernel-owner+w=401wt.eu-S1764733AbYBTDCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764733AbYBTDCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 22:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbYBTDCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 22:02:41 -0500
Received: from smtp-out.google.com ([216.239.45.13]:28537 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049AbYBTDCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 22:02:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=eOFYEzp2c5HqctPCSiGgp07DmaeEC9sPriJ6gqvtc78u+YsXruIWtjDvkR6DvzG2+
	57Fg4YFlvh4W+HdEgaC4g==
Message-ID: <6599ad830802191902n7b15591eqc471d1bbe923a36f@mail.gmail.com>
Date: Tue, 19 Feb 2008 19:02:35 -0800
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 6/7] cgroup: remove duplicate code in find_css_set()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
In-Reply-To: <47B91C84.4080806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B91C84.4080806@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2008 9:49 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> The list head res->tasks gets initialized twice in find_css_set().
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

> ---
>  kernel/cgroup.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index e8c8e58..71cf961 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -473,7 +473,6 @@ static struct css_set *find_css_set(
>         /* Link this cgroup group into the list */
>         list_add(&res->list, &init_css_set.list);
>         css_set_count++;
> -       INIT_LIST_HEAD(&res->tasks);
>         write_unlock(&css_set_lock);
>
>         return res;
> --
> 1.5.4.rc3
>
>
