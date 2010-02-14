Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab0BNWCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 17:02:17 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:50823 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab0BNWCQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 17:02:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=meqqB6q23hu0jOyR6gq5tCDe829LA5SDwuTcD9Jf69JnfvMByRzIgviwkEVGFvZdVu
         lSayDoddtmwTk9NnzuNU+YwJBMpJKrUvrUP+HmwA1CXkBZdjMoAEAD1c+EwF98fdHVV8
         kvzeRkw1B4iQVZ+FhQY+cPNg/yuoSLA1Sdvk8=
MIME-Version: 1.0
In-Reply-To: <1266178376-6763-1-git-send-email-al3xbio@gmail.com>
References: <1266178376-6763-1-git-send-email-al3xbio@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 14 Feb 2010 23:01:25 +0100
Message-ID: <69e28c911002141401q3ca8810djc5f1775dfd0d6f3@mail.gmail.com>
Subject: Re: [PATCH 2/2] Staging: wlan-ng: fix most of the style issues in 
	hfa384x.h
To: Alessandro Ghedini <al3xbio@gmail.com>
Cc: gregkh@suse.de, jmm@debian.org, mithlesh@linsyssoft.com,
       karllinuxtest.relton@ntlworld.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You posted the wrong patch - this is only an interdiff.

Also, it might be a good idea to reduce the spacing for all entries,
not just these "overdone" ones, to keep them lined-up nicely.

On Sun, Feb 14, 2010 at 9:12 PM, Alessandro Ghedini <al3xbio@gmail.com> wrote:
> This patch fixes all the errors and the majority of the warnings found with
> checkpatch.pl script in hfa384x.h, following Gábor Stefanik hints
>
> Signed-off-by: Alessandro Ghedini <al3xbio@gmail.com>
> ---
>  drivers/staging/wlan-ng/hfa384x.h |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/staging/wlan-ng/hfa384x.h b/drivers/staging/wlan-ng/hfa384x.h
> index 8e39f76..3d440f8 100644
> --- a/drivers/staging/wlan-ng/hfa384x.h
> +++ b/drivers/staging/wlan-ng/hfa384x.h
> @@ -63,15 +63,9 @@
>  /*--- Mins & Maxs -----------------------------------*/
>  #define                HFA384x_PORTID_MAX              ((u16)7)
>  #define                HFA384x_NUMPORTS_MAX            ((u16)(HFA384x_PORTID_MAX+1))
> -#define                HFA384x_PDR_LEN_MAX             ((u16)512)      /*
> -                                                                * in bytes,
> -                                                                * from EK
> -                                                                */
> +#define                HFA384x_PDR_LEN_MAX     ((u16)512)      /* in bytes, from EK */
>  #define                HFA384x_PDA_RECS_MAX            ((u16)200)      /* a guess */
> -#define                HFA384x_PDA_LEN_MAX             ((u16)1024)     /*
> -                                                                * in bytes,
> -                                                                * from EK
> -                                                                */
> +#define                HFA384x_PDA_LEN_MAX     ((u16)1024)     /* in bytes, from EK*/
>  #define                HFA384x_SCANRESULT_MAX          ((u16)31)
>  #define                HFA384x_HSCANRESULT_MAX         ((u16)31)
>  #define                HFA384x_CHINFORESULT_MAX        ((u16)16)
> --
> 1.6.6.2
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
