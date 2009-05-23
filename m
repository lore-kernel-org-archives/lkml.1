Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZEWNP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZEWNP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 09:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZEWNPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 09:15:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32807 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbZEWNPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 09:15:17 -0400
Subject: Re: [PATCH] forget a blankspace before 'name'
From: Eric Paris <eparis@redhat.com>
To: Zhenwen Xu <helight.xu@gmail.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
In-Reply-To: <20090523101049.GA7209@helight>
References: <20090523101049.GA7209@helight>
Content-Type: text/plain
Date: Sat, 23 May 2009 09:13:36 -0400
Message-Id: <1243084416.7675.0.camel@dhcp231-142.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-23 at 18:10 +0800, Zhenwen Xu wrote:
> here should add some space before "name="

NAK.

/* This is a helper-function to print the escaped d_path */
void audit_log_d_path(struct audit_buffer *ab, const char *prefix,
                      struct path *path)
{
        char *p, *pathname;

        if (prefix)
                audit_log_format(ab, " %s", prefix);

Look there, a space before the prefix.




> Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
> ---
>  kernel/auditsc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 7d6ac7c..aa0428e 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -1478,7 +1478,7 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
>  			case 0:
>  				/* name was specified as a relative path and the
>  				 * directory component is the cwd */
> -				audit_log_d_path(ab, "name=", &context->pwd);
> +				audit_log_d_path(ab, " name=", &context->pwd);
>  				break;
>  			default:
>  				/* log the name's directory component */
> -- 
> 1.5.6.5
> 

