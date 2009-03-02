Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589AbZCBNHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbZCBNHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 08:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZCBNG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 08:06:56 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:59833 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZCBNG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 08:06:56 -0500
Date: Mon, 2 Mar 2009 07:06:52 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 3/4] devcgroup: show correct file mode
Message-ID: <20090302130652.GA6628@us.ibm.com>
References: <49AB40BF.4030706@cn.fujitsu.com> <49AB4143.9050704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AB4143.9050704@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Li Zefan (lizf@cn.fujitsu.com):
> devices.allow and devices.deny are write-only, and devices.list is read-only.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Yup that should be intuitive for people.

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge

> ---
>  security/device_cgroup.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 3aacd0f..b13fbb8 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -439,16 +439,19 @@ static struct cftype dev_cgroup_files[] = {
>  		.name = "allow",
>  		.write_string  = devcgroup_access_write,
>  		.private = DEVCG_ALLOW,
> +		.mode = 0200,
>  	},
>  	{
>  		.name = "deny",
>  		.write_string = devcgroup_access_write,
>  		.private = DEVCG_DENY,
> +		.mode = 0200,
>  	},
>  	{
>  		.name = "list",
>  		.read_seq_string = devcgroup_seq_read,
>  		.private = DEVCG_LIST,
> +		.mode = 0444,
>  	},
>  };
> 
> -- 1.5.4.rc3 
