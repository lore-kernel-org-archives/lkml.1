Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbZLAHpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbZLAHpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZLAHpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:45:19 -0500
Received: from mail.perches.com ([173.55.12.10]:1206 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbZLAHpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:45:18 -0500
Subject: Re: [Patch] selinux: remove an unreachable line
From: Joe Perches <joe@perches.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org, akpm@linux-foundation.org,
       James Morris <jmorris@namei.org>
In-Reply-To: <20091201074422.4410.60874.sendpatchset@localhost.localdomain>
References: <20091201074422.4410.60874.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 23:45:23 -0800
Message-ID: <1259653523.21388.7.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 02:41 -0500, Amerigo Wang wrote:
> This line is unreachable, remove it.
[]
> diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
> index b5407f1..a2f1034 100644
> --- a/security/selinux/ss/mls.c
> +++ b/security/selinux/ss/mls.c
> @@ -544,7 +544,6 @@ int mls_compute_sid(struct context *scontext,
>  	default:
>  		return -EINVAL;
>  	}
> -	return -EINVAL;
>  }

I think it's better to remove the default case.

