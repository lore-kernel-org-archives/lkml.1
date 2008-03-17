Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbYCQVjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbYCQVjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 17:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYCQVjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 17:39:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbYCQVjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 17:39:17 -0400
Subject: Re: [2.6 patch] make selinux_parse_opts_str() static
From: Eric Paris <eparis@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
       Casey Schaufler <casey@schaufler-ca.com>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080317202923.GC9550@cs181133002.pp.htv.fi>
References: <20080317202923.GC9550@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 17:36:01 -0400
Message-Id: <1205789761.2431.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-17 at 22:29 +0200, Adrian Bunk wrote:
> This patch makes the needlessly global selinux_parse_opts_str() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Ack-ed by: Eric Paris <eparis@redhat.com>

whoops, sorry.

> ---
> 42740a04634e3a4362a688b29ad31ee87c940ff7 diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 4bf4807..41a049f 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -800,7 +800,8 @@ static void selinux_sb_clone_mnt_opts(const struct super_block *oldsb,
>  	mutex_unlock(&newsbsec->lock);
>  }
>  
> -int selinux_parse_opts_str(char *options, struct security_mnt_opts *opts)
> +static int selinux_parse_opts_str(char *options,
> +				  struct security_mnt_opts *opts)
>  {
>  	char *p;
>  	char *context = NULL, *defcontext = NULL;
> 

