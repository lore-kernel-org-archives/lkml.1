Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbZIQCOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbZIQCOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 22:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbZIQCOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 22:14:04 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:52802 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbZIQCOC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 22:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LZ9WGv8c43ZNRlbIGUkp9CoDPpavdzzdgY6vXAbC9AF3lHnrtWHv1JVZFQCbYExo6x
         AS+eibYEdE96JVg02F2lRW9RgoMPByFIV59xV9TAbyD8wPgjd7lzhfKbGuLfXIAYHpun
         S+CdYV/WRh6IEaC0bwrK6itsuiCrzDG0R/q1M=
MIME-Version: 1.0
In-Reply-To: <1253137123-18047-4-git-send-email-felipe.contreras@gmail.com>
References: <1253137123-18047-1-git-send-email-felipe.contreras@gmail.com>
	 <1253137123-18047-2-git-send-email-felipe.contreras@gmail.com>
	 <1253137123-18047-3-git-send-email-felipe.contreras@gmail.com>
	 <1253137123-18047-4-git-send-email-felipe.contreras@gmail.com>
Date: Thu, 17 Sep 2009 10:14:05 +0800
Message-ID: <2375c9f90909161914t3470dedne872364b2c446755@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] kbuild: mkcompile_h: trivial cleanups
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 5:38 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> UTS_TRUNCATTE is simpler this way, and now editors idetify this as a
> shell script.
>
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

Looks good.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

> ---
>  scripts/mkcompile_h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/mkcompile_h b/scripts/mkcompile_h
> index f060763..bce3d0f 100755
> --- a/scripts/mkcompile_h
> +++ b/scripts/mkcompile_h
> @@ -1,3 +1,5 @@
> +#!/bin/sh
> +
>  TARGET=$1
>  ARCH=$2
>  SMP=$3
> @@ -50,7 +52,7 @@ UTS_VERSION="$UTS_VERSION $CONFIG_FLAGS $TIMESTAMP"
>  # Truncate to maximum length
>
>  UTS_LEN=64
> -UTS_TRUNCATE="sed -e s/\(.\{1,$UTS_LEN\}\).*/\1/"
> +UTS_TRUNCATE="cut -b -$UTS_LEN"
>
>  # Generate a temporary compile.h
>
> --
> 1.6.5.rc1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
