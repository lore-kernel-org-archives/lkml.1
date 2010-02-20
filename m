Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab0BTCbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 21:31:21 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:7975 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab0BTCbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 21:31:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=beTf5G7jixXz++GLKhE+a7aTSMgzMqT4Kk0d4dMMGBXHR7WNLZc0rC4koxadEZPNNJ
         DcFoQQFq8hjfDZC8lWw9hdrUifl9P/JEezf4Z0nwgIpVVdXphOjh6YGW0wFQuJOW+bL3
         T+jj67/8LcMszWY6ayGO0vtRrCr0M4iPQ+Lso=
MIME-Version: 1.0
In-Reply-To: <1266582790-11506-1-git-send-email-jglisse@redhat.com>
References: <1266582790-11506-1-git-send-email-jglisse@redhat.com>
Date: Sat, 20 Feb 2010 10:31:18 +0800
Message-ID: <2375c9f91002191831y10918541mb5e2463d97c8f3ae@mail.gmail.com>
Subject: Re: [PATCH] git ignore *.builtin generated file
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Jerome Glisse <jglisse@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 8:33 PM, Jerome Glisse <jglisse@redhat.com> wrote:
> This patch makes git ignore any *.builtin file (best patch of the year)
>
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>


Sorry, besides "modules.builtin", what other builtin files did you see?
We already exclude "modules.builtin".

> ---
>  .gitignore |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/.gitignore b/.gitignore
> index 946c7ec..2db1c56 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -29,6 +29,7 @@
>  *.lzma
>  *.patch
>  *.gcno
> +*.builtin
>
>  #
>  # Top-level generic files
> --
> 1.6.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
