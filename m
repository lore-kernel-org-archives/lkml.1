Return-Path: <linux-kernel-owner+w=401wt.eu-S933852AbYDQPa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933852AbYDQPa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761310AbYDQPau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:30:50 -0400
Received: from web36607.mail.mud.yahoo.com ([209.191.85.24]:20421 "HELO
	web36607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760635AbYDQPat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:30:49 -0400
X-YMail-OSG: 7LKta4MVM1l0HXzOBKg1tZn4FNIL6EU8zbw5Y3Y9xv2b542RY5u9WpFVVmZ7DwKZkk5DhLIFaSumWeHu2S9hJhF8CtsPauhk.pxfOHJF3W8QinHQfLb1PxlwGjA-
X-RocketYMMF: rancidfat
Date: Thu, 17 Apr 2008 08:30:47 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 12/12] security: fix up documentation for security_module_enable
To: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>
In-Reply-To: <2fc4d0d4427f622c2f9a2c119f9de0241464ef44.1208428766.git.jmorris@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <109225.87914.qm@web36607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- James Morris <jmorris@namei.org> wrote:

> security_module_enable() can only be called during kernel init.
> 
> Signed-off-by: James Morris <jmorris@namei.org>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

> ---
>  security/security.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/security.c b/security/security.c
> index 2ed153c..7787c59 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -83,7 +83,7 @@ __setup("security=", choose_lsm);
>   *
>   * Each LSM must pass this method before registering its own operations
>   * to avoid security registration races. This method may also be used
> - * to check if your LSM is currently loaded.
> + * to check if your LSM is currently loaded during kernel initialization.
>   *
>   * Return true if:
>   *	-The passed LSM is the one chosen by user at boot time,
> -- 
> 1.5.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
