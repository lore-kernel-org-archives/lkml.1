Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab0CISuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:50:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:5248 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab0CISuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:50:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vg5Rgot/NJ2UCJ8i+ewdiriyk8XWJgZEO7+FoJ+DK1EKK73CBWv9XGniLEioZD9Afh
         Ish4AvgIQXg0Y4SnB20uUw7Gj5nLxDLFTRy1EN27nphv2qyN/jhubXF3AgqN+CT2luxa
         tep1Z821bF/u16zNW4eBzSiC19aBRwVUvhbnU=
MIME-Version: 1.0
In-Reply-To: <4B969026.8040106@intcomgrp.com>
References: <elUoX-6na-35@gated-at.bofh.it> <4B967AEE.2060905@intcomgrp.com>
	 <f5ca57691003090901r399b1e78yb66c8ef4fe15440b@mail.gmail.com>
	 <4B9683CF.5040402@intcomgrp.com>
	 <f5ca57691003090939u71bf7171nc8069b0a62c562be@mail.gmail.com>
	 <4B969026.8040106@intcomgrp.com>
Date: Tue, 9 Mar 2010 15:50:17 -0300
Message-ID: <f5ca57691003091050l8589a5al7ee3dfef78432e35@mail.gmail.com>
Subject: Re: [PATCH] Security: key: keyring: fix some code style issues
From: Chihau Chau <chihau@gmail.com>
To: James Kosin <jkosin@intcomgrp.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now I understand. Sorry for my little confusion.

I am making a new patch.

Thanks!

2010/3/9 James Kosin <jkosin@intcomgrp.com>:
> On 3/9/2010 12:39 PM, Chihau Chau wrote:
> Chau,
>
> Below is your original patch set.
>
> From: Chihau Chau <chihau@gmail.com>
>
> This fixes some code style issues like to include <linux/uaccess.h> instead
> <asm/uaccess.h> and to remove some innecessary braces.
>
> Signed-off-by: Chihau Chau <chihau@gmail.com>
> ---
>  security/keys/keyring.c |   11 ++++-------
>  1 files changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> index e814d21..5a44965 100644
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
> @@ -170,12 +170,10 @@ static void keyring_describe(const struct key
> *keyring, struct seq_file *m)
>  {
>  	struct keyring_list *klist;
>
> -	if (keyring->description) {
> +	if (keyring->description)
>  		seq_puts(m, keyring->description);
> -	}
> -	else {
> +	else
>  		seq_puts(m, "[anon]");
> -	}
>
>
> Here is where I said NOT to remove the braces.  However you can see the
> style of the if() {} else {} blocks is not the same as below where you point
> to the style of the statements as to the reason for the change.
>
>
>  	rcu_read_lock();
>  	klist = rcu_dereference(keyring->payload.subscriptions);
> @@ -775,8 +773,7 @@ int __key_link(struct key *keyring, struct key *key)
>  		smp_wmb();
>  		klist->nkeys++;
>  		smp_wmb();
> -	}
> -	else {
> +	} else {
>  		/* grow the key list */
>  		max = 4;
>
>
> See HERE.
>
> 		if (klist)
> --
> 1.5.6.3
>
> One of these is wrong.  Check the coding style document as to which is
> correct.
>
> Sorry to be so critical.
>
> Regards,
> James K.
>



-- 
Chihau Chau
