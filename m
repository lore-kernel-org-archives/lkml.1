Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbZKHUoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbZKHUoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbZKHUoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:44:00 -0500
Received: from gate.crashing.org ([63.228.1.57]:34686 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642AbZKHUn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:43:59 -0500
Subject: Re: [PATCH 19/23] sysctl powerpc: Remove dead binary sysctl support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: <1257682930-31401-19-git-send-email-ebiederm@xmission.com>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
	 <1257682930-31401-19-git-send-email-ebiederm@xmission.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 07:44:00 +1100
Message-ID: <1257713040.13611.280.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-08 at 04:22 -0800, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Now that sys_sysctl is a generic wrapper around /proc/sys  .ctl_name
> and .strategy members of sysctl tables are dead code.  Remove them.
> 
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  arch/powerpc/kernel/idle.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
> index 88d9c1d..cece9e2 100644
> --- a/arch/powerpc/kernel/idle.c
> +++ b/arch/powerpc/kernel/idle.c
> @@ -110,7 +110,6 @@ int powersave_nap;
>   */
>  static ctl_table powersave_nap_ctl_table[]={
>  	{
> -		.ctl_name	= KERN_PPC_POWERSAVE_NAP,
>  		.procname	= "powersave-nap",
>  		.data		= &powersave_nap,
>  		.maxlen		= sizeof(int),
> @@ -121,7 +120,6 @@ static ctl_table powersave_nap_ctl_table[]={
>  };
>  static ctl_table powersave_nap_sysctl_root[] = {
>  	{
> -		.ctl_name	= CTL_KERN,
>  		.procname	= "kernel",
>  		.mode		= 0555,
>  		.child		= powersave_nap_ctl_table,


