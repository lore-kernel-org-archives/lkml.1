Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbZCDOcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbZCDOcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 09:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbZCDOc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 09:32:27 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:34639 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678AbZCDOcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 09:32:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QASGl8i8BlbVFZ3e+dNl0hcBpP0YZbFa7KQVRQXvMnUo2XMekBxO/1+07kInSR8jCB
         fjKI0UxKti4WeI8/fJ8UNGcO6VA2oA+Y2eC5FJDVakulCU/cN3F9BCXrbVHiZ6uWEFtV
         iugo86bQmOuxQQR8HLN18P3JjzhAullsyVpl8=
MIME-Version: 1.0
In-Reply-To: <E1LerZg-0000Rp-AX@mailer.emlix.com>
References: <E1LerZg-0000Rp-AX@mailer.emlix.com>
Date: Wed, 4 Mar 2009 16:32:22 +0200
X-Google-Sender-Auth: 4e82230140a9eb41
Message-ID: <84144f020903040632q6c589cb2q6c976ea999c65956@mail.gmail.com>
Subject: Re: [patch] xtensa: enforce slab alignment to maximum register width
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Johannes Weiner <jw@emlix.com>
Cc: Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 4, 2009 at 3:56 PM, Johannes Weiner <jw@emlix.com> wrote:
> From: Oskar Schirmer <os@emlix.com>
>
> XCHAL_DATA_WIDTH is the maximum register width, slab caches should be
> aligned to this.
>
> Theoretical fix as all variants have had an XCHAL_DATA_WIDTH of 4
> (wordsize) for now.  But the S6000 variant will raise this to 16.
>
> Signed-off-by: Oskar Schirmer <os@emlix.com>
> Signed-off-by: Johannes Weiner <jw@emlix.com>
> ---
>  arch/xtensa/include/asm/processor.h |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- a/arch/xtensa/include/asm/processor.h
> +++ b/arch/xtensa/include/asm/processor.h
> @@ -25,6 +25,8 @@
>  # error Linux requires the Xtensa Windowed Registers Option.
>  #endif
>
> +#define ARCH_SLAB_MINALIGN     XCHAL_DATA_WIDTH
> +

Looks good to me!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
