Return-Path: <linux-kernel-owner+w=401wt.eu-S1762927AbZDHMb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762927AbZDHMb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758992AbZDHMbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:31:13 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:61418 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbZDHMbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:31:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pxi6gweAuo1soEhRm7rzVi1Ej3Ve3PVq3Zwhu8BfdnQpkWY6uuTy1QSJfo4+fIl0vW
         AwamYq/gDXKWWsv2j/O+IDMp13if4zR1P0HU9h+cciPlqjaQB27oHB/YgQymLZmCw0Bc
         2WOJqSHOGv69KyFvoia78XuVEl7rrKGq6EcZI=
MIME-Version: 1.0
In-Reply-To: <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
Date: Wed, 8 Apr 2009 14:31:08 +0200
Message-ID: <36ca99e90904080531p5167e7f6j12617436084fabfa@mail.gmail.com>
Subject: Re: [PATCH 29/56] irda: Remove void casts
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 13:22, Jack Stone <jwjstone@fastmail.fm> wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  net/irda/discovery.c         |    4 ++--
>  net/irda/ircomm/ircomm_lmp.c |    2 +-
>  net/irda/iriap.c             |    2 +-
>  net/irda/irnet/irnet_irda.c  |    2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/net/irda/irnet/irnet_irda.c b/net/irda/irnet/irnet_irda.c
> index cf9a4b5..213f207 100644
> --- a/net/irda/irnet/irnet_irda.c
> +++ b/net/irda/irnet/irnet_irda.c
> @@ -766,7 +766,7 @@ irnet_find_socket(irnet_socket *    self)
>    * requested that nickname */
>   if(err == 0)
>     {
> -      new = (irnet_socket *) hashbin_find(irnet_server.list,
> +      new = hashbin_find(irnet_server.list,
>                                          0, self->rname);
Please check.

>       if(new)
>        DEBUG(IRDA_SERV_INFO, "Socket 0x%p matches rname ``%s''.\n",
> --
Bert
