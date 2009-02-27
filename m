Return-Path: <linux-kernel-owner+w=401wt.eu-S1760394AbZB0BBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394AbZB0BBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 20:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbZB0BAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 20:00:50 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:61927 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbZB0BAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 20:00:49 -0500
MIME-Version: 1.0
In-Reply-To: <20090222000204.17557.99725.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
	 <20090222000204.17557.99725.stgit@vmbox.hanneseder.net>
Date: Fri, 27 Feb 2009 02:00:46 +0100
Message-ID: <154e089b0902261700j4131b0feq8f0e29885a833590@mail.gmail.com>
Subject: Re: [PATCH 05/16] dvb: fix sparse warnings: Using plain integer as 
	NULL pointer
From: Hannes Eder <hannes@hanneseder.net>
To: trivial@kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added To]

On Sun, Feb 22, 2009 at 1:02 AM, Hannes Eder <hannes@hanneseder.net> wrote:
> Fix this sparse warnings:
>  drivers/media/dvb/frontends/drx397xD_fw.h:21:2: warning: Using plain integer as NULL pointer
>  drivers/media/dvb/frontends/drx397xD_fw.h:22:2: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  drivers/media/dvb/frontends/drx397xD.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/dvb/frontends/drx397xD.c b/drivers/media/dvb/frontends/drx397xD.c
> index 1e81e71..172f1f9 100644
> --- a/drivers/media/dvb/frontends/drx397xD.c
> +++ b/drivers/media/dvb/frontends/drx397xD.c
> @@ -74,7 +74,7 @@ static struct {
>  } fw[] = {
>  #define _FW_ENTRY(a, b, c)     {                                       \
>                        .name   = a,                                    \
> -                       .file   = 0,                                    \
> +                       .file   = NULL,                                 \
>                        .lock   = __RW_LOCK_UNLOCKED(fw[c].lock),       \
>                        .refcnt = 0,                                    \
>                        .data   = { }           }
>
>
