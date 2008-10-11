Return-Path: <linux-kernel-owner+w=401wt.eu-S1760752AbYJKVx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752AbYJKVx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 17:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbYJKVxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 17:53:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:47957 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbYJKVxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 17:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=VKcpwq57yid3ykF0fnzyQjwy+qUo/b6BT+eQ+sKG8STWhFPt82WnOa8NDGCEwrID68
         RbcE0/j9/4evgnv12n6AGPc+KFIPZg3Wyz5aSpr4QbCz+hVVYcGZgvPdl4ZGYYtPw5AD
         T5UoCXMSzTC1oaCQUP8gtmEslEqdpoLH/Pv60=
Message-ID: <86802c440810111453r7af9637br277710a5e5def8d2@mail.gmail.com>
Date: Sat, 11 Oct 2008 14:53:48 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: [PATCH] kernel/resource: fix printk format warning
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20081011205822.GA25563@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081011205822.GA25563@orion>
X-Google-Sender-Auth: f1469784ce02f6f5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2008 at 1:58 PM, Alexander Beregalov
<a.beregalov@gmail.com> wrote:
>
>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
>
>  kernel/resource.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 414d6fc..cfe0933 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -550,8 +550,8 @@ static void __init __reserve_region_with_split(struct resource *root,
>
>        if (!res) {
>                printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
> -                        conflict->name, conflict->start, conflict->end,
> -                        name, start, end);
> +                        conflict->name, (unsigned long long)conflict->start, (unsigned long long)conflict->end,
> +                        name, (unsigned long long)start, (unsigned long long)end);
>
>                /* failed, split and try again */

Ingo should already have one patch in tip to remove that print out.

YH
