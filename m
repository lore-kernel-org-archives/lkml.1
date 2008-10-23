Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYJWMh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYJWMh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 08:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYJWMhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 08:37:46 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:43729 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbYJWMhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 08:37:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=pEyhb1I1uKKhiAl3KaDeNnsWMto5OkCQNhR8hF0aibFDnYd5oGA+tRTpBIY8c33R3F
         RfzgWRnp7TSHJVK+sn0Yu4dwhcJYE28rDVdwEHHJeQq9Y7UiLLdhcjWhnSIhfKAardYJ
         uYvk/goa3Tps8YaAW4dGJ9kQjo76ggJqBDP84=
Message-ID: <9ea470500810230537u559fff3chda7c6f47927bf1b0@mail.gmail.com>
Date: Thu, 23 Oct 2008 14:37:44 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "=?ISO-8859-1?Q?N=E9meth_M=E1rton?=" <nm127@freemail.hu>
Subject: Re: [PATCH] cdrom: add TEAC CD-224E to the NO_AUTOCLOSE list
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
In-Reply-To: <4900655E.7050906@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <4900655E.7050906@freemail.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 1:51 PM, Németh Márton <nm127@freemail.hu> wrote:
> From: Márton Németh <nm127@freemail.hu>
>
> The "TEAC CD-ROM CD-224E" cannot close its tray, so add it to the NO_AUTOCLOSE list. This
> will correct the "Can close tray" field of /proc/sys/dev/cdrom/info.
>
> Signed-off-by: Márton Németh <nm127@freemail.hu>

Acked-by: Borislav Petkov <petkovbb@gmail.com>

> ---
> --- linux-2.6.27/drivers/ide/ide-cd.c.orig      2008-10-10 00:13:53.000000000 +0200
> +++ linux-2.6.27/drivers/ide/ide-cd.c   2008-10-23 11:34:59.000000000 +0200
> @@ -1863,6 +1863,7 @@ static const struct cd_list_entry ide_cd
>        { "Optiarc DVD RW AD-5200A", NULL,   IDE_AFLAG_PLAY_AUDIO_OK         },
>        { "Optiarc DVD RW AD-7200A", NULL,   IDE_AFLAG_PLAY_AUDIO_OK         },
>        { "Optiarc DVD RW AD-7543A", NULL,   IDE_AFLAG_NO_AUTOCLOSE          },
> +       { "TEAC CD-ROM CD-224E",     NULL,   IDE_AFLAG_NO_AUTOCLOSE          },
>        { NULL, NULL, 0 }
>  };
>
>

-- 
Regards/Gruss,
Boris
