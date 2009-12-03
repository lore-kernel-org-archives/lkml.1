Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbZLCOY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbZLCOY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbZLCOYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:24:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119AbZLCOYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:24:24 -0500
Subject: Re: [Patch] selinux: remove a useless return
From: Eric Paris <eparis@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org, akpm@linux-foundation.org,
       James Morris <jmorris@namei.org>
In-Reply-To: <20091203085127.4370.1737.sendpatchset@localhost.localdomain>
References: <20091203085127.4370.1737.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Dec 2009 09:23:53 -0500
Message-Id: <1259850233.2613.0.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 03:48 -0500, Amerigo Wang wrote:
> The last return is unreachable, remove the 'return'
> in default, let it fall through.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: Eric Paris <eparis@parisplace.org>

Acked-by: Eric Paris <eparis@redhat.com>

> 
> ---
> 
> diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
> index b5407f1..718823d 100644
> --- a/security/selinux/ss/mls.c
> +++ b/security/selinux/ss/mls.c
> @@ -542,7 +542,7 @@ int mls_compute_sid(struct context *scontext,
>  		/* Use the process effective MLS attributes. */
>  		return mls_context_cpy_low(newcontext, scontext);
>  	default:
> -		return -EINVAL;
> +		/* Fallthrough */
>  	}
>  	return -EINVAL;
>  }


