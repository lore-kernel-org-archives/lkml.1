Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab0CIQmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:42:23 -0500
Received: from server109i.appriver.com ([72.32.253.93]:3195 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753530Ab0CIQmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:42:21 -0500
X-Policy: GLOBAL - intcomgrp.com
X-Primary: jkosin@intcomgrp.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: JKosin@intcomgrp.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 216.54.13.100
X-Note-Reverse-DNS: mail.intcomgrp.com
X-Note-WHTLIST: JKosin@intcomgrp.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G179 G180 G181 G182 G186 G187 G198 G285 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
Message-ID: <4B967AEE.2060905@intcomgrp.com>
Date: Tue, 09 Mar 2010 11:44:30 -0500
From: James Kosin <jkosin@intcomgrp.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Security: key: keyring: fix some code style issues
References: <elUoX-6na-35@gated-at.bofh.it>
In-Reply-To: <elUoX-6na-35@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2010 16:44:30.0547 (UTC) FILETIME=[CA26E230:01CABFA7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/2010 6:20 PM, Chihau Chau wrote:
> From: Chihau Chau <chihau@gmail.com>
> 
> This fixes to include <linux/uaccess.h> instead <asm/uaccess.h> and some
> code style issues like to put a else sentence below close brace '}' and
> to replace a tab instead of some space characters.
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>
> ---
>  security/keys/keyring.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> index e814d21..840be66 100644
> --- a/security/keys/keyring.c
> +++ b/security/keys/keyring.c
> @@ -17,7 +17,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/err.h>
>  #include <keys/keyring-type.h>
> -#include <asm/uaccess.h>
> +#include <linux/uaccess.h>
>  #include "internal.h"
>  
>  /*
> @@ -306,7 +306,7 @@ key_ref_t keyring_search_aux(key_ref_t keyring_ref,
>  	key_check(keyring);
>  
>  	/* top keyring must have search permission to begin the search */
> -        err = key_task_permission(keyring_ref, cred, KEY_SEARCH);
> +	err = key_task_permission(keyring_ref, cred, KEY_SEARCH);
>  	if (err < 0) {
>  		key_ref = ERR_PTR(err);
>  		goto error;
> @@ -775,8 +775,7 @@ int __key_link(struct key *keyring, struct key *key)
>  		smp_wmb();
>  		klist->nkeys++;
>  		smp_wmb();
> -	}
> -	else {
> +	} else {
>  		/* grow the key list */
>  		max = 4;
>  		if (klist)

Chau,

What happened to the other part of the patch to fix the "} else {" above
where you had tried to remove the {} ?

James
