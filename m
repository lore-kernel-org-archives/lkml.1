Return-Path: <linux-kernel-owner+w=401wt.eu-S1762857AbYA1Wis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762857AbYA1Wis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762209AbYA1Wig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:38:36 -0500
Received: from namei.org ([69.55.235.186]:40806 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762112AbYA1Wie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:38:34 -0500
Date: Tue, 29 Jan 2008 09:37:30 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Adrian Bunk <bunk@kernel.org>
cc: Eric Paris <eparis@redhat.com>, "Stephen D. Smalley" <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make selinux_set_mnt_opts() static
In-Reply-To: <20080128221152.GC8767@does.not.exist>
Message-ID: <Xine.LNX.4.64.0801290937220.22649@us.intercode.com.au>
References: <20080128221152.GC8767@does.not.exist>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Adrian Bunk wrote:

> selinux_set_mnt_opts() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 

Thanks, applied.


> ---
> d9cfb159caa25ed5ad3dee35d62a6e1a0bd51ef6 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 0396354..04eeab7 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -561,8 +561,8 @@ static int bad_option(struct superblock_security_struct *sbsec, char flag,
>   * Allow filesystems with binary mount data to explicitly set mount point
>   * labeling information.
>   */
> -int selinux_set_mnt_opts(struct super_block *sb, char **mount_options,
> -				 int *flags, int num_opts)
> +static int selinux_set_mnt_opts(struct super_block *sb, char **mount_options,
> +				int *flags, int num_opts)
>  {
>  	int rc = 0, i;
>  	struct task_security_struct *tsec = current->security;
> 

-- 
James Morris
<jmorris@namei.org>
