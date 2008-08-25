Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbYHYQoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbYHYQoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 12:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbYHYQn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 12:43:59 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56274 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbYHYQn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 12:43:58 -0400
Date: Mon, 25 Aug 2008 11:43:49 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] devcgroup: remove unused variable
Message-ID: <20080825164349.GC13583@us.ibm.com>
References: <48B2175E.3070407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B2175E.3070407@cn.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Li Zefan (lizf@cn.fujitsu.com):
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Yup.

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge

> ---
>  security/device_cgroup.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 9c625f6..d5c15a7 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -355,7 +355,7 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
>  	struct dev_cgroup *cur_devcgroup;
>  	const char *b;
>  	char *endp;
> -	int retval = 0, count;
> +	int count;
>  	struct dev_whitelist_item wh;
> 
>  	if (!capable(CAP_SYS_ADMIN))
> @@ -432,7 +432,6 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
>  	}
> 
>  handle:
> -	retval = 0;
>  	switch (filetype) {
>  	case DEVCG_ALLOW:
>  		if (!parent_has_perm(devcgroup, &wh))
> -- 
> 1.5.4.rc3
> 
