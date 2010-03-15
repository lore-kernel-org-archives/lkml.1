Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936245Ab0COMyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 08:54:18 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56408 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936218Ab0COMyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 08:54:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=lSlW46NwGJao8pyeMU7/YU+fI/3KkSQjIEK8SNheGbothQgzeM4PPv/3momPX1rhl7
         UniGNsdp1MN32oHrx86uBRRoDvT6g1y9cztgauTHDqHKTPlm9bhfwFn5fZHw0u4spIDc
         DJYVQrdLVtzJb24kluOzEsWrGTC4f/Q138wq8=
MIME-Version: 1.0
In-Reply-To: <20100315082148.GD18181@bicker>
References: <20100315082148.GD18181@bicker>
Date: Mon, 15 Mar 2010 13:54:15 +0100
Message-ID: <8aa016e11003150554h549a5853o7b21773915ac2451@mail.gmail.com>
Subject: Re: [patch] sched: remove some dead code
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Dan Carpenter <error27@gmail.com>, Dhaval Giani <dhaval.giani@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Kay Sievers <kay.sievers@vrfy.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 9:21 AM, Dan Carpenter <error27@gmail.com> wrote:
> This was left over from "7c9414385e sched: Remove USER_SCHED"
>

Quite surprising I missed that. Thanks for catching it.

> Signed-off-by: Dan Carpenter <error27@gmail.com>
>

Acked-by: Dhaval Giani <dhaval.giani@gmail.com>

> diff --git a/kernel/user.c b/kernel/user.c
> index 766467b..ec3b222 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -178,8 +178,6 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
>
>        return up;
>
> -       put_user_ns(new->user_ns);
> -       kmem_cache_free(uid_cachep, new);
>  out_unlock:
>        return NULL;
>  }
>
