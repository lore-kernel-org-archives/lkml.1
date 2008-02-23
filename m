Return-Path: <linux-kernel-owner+w=401wt.eu-S932951AbYBWACU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbYBWACU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757852AbYBWACM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:02:12 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40837 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758737AbYBWACK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:02:10 -0500
Date: Fri, 22 Feb 2008 18:02:06 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/ns_cgroup.c should #include
	<linux/nsproxy.h>
Message-ID: <20080223000206.GA14216@sergelap.austin.ibm.com>
References: <20080222195826.GG1409@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222195826.GG1409@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Adrian Bunk (bunk@kernel.org):
> Every file should include the headers containing the externs its global 
> functions (in this case for ns_cgroup_clone()).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Seems fine...  and a good way to ensure that the prototype and
definition match.

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge

> 
> ---
> d3446a02068091d59425c51bde1daea777398e44 diff --git a/kernel/ns_cgroup.c b/kernel/ns_cgroup.c
> index aead4d6..659f321 100644
> --- a/kernel/ns_cgroup.c
> +++ b/kernel/ns_cgroup.c
> @@ -7,6 +7,7 @@
>  #include <linux/module.h>
>  #include <linux/cgroup.h>
>  #include <linux/fs.h>
> +#include <linux/nsproxy.h>
> 
>  struct ns_cgroup {
>  	struct cgroup_subsys_state css;
