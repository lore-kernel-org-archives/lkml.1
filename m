Return-Path: <linux-kernel-owner+w=401wt.eu-S934195AbZDIKk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195AbZDIKk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934013AbZDIKjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:39:14 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50158 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933994AbZDIKjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:39:11 -0400
X-Sasl-enc: pjpN96O9B9958F7abisL/Cqw7WtyjgVzmdqialiHylcP 1239273550
Message-ID: <49DDD04B.90107@fastmail.fm>
Date: Thu, 09 Apr 2009 11:39:07 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, jeremy@xensource.com,
       chrisw@sous-sol.org
Subject: Re: [PATCH 55/56] xen: Remove void casts
References: <> <1239189748-11703-41-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-42-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-43-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-44-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-45-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-46-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-47-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-48-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-56-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-56-git-send-email-jwjstone@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CCs]
Jack Stone wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  drivers/xen/manage.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> index 0d61db1..89310fb 100644
> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
> @@ -149,7 +149,7 @@ static void shutdown_handler(struct xenbus_watch *watch,
>  	if (err)
>  		return;
>  
> -	str = (char *)xenbus_read(xbt, "control", "shutdown", NULL);
> +	str = xenbus_read(xbt, "control", "shutdown", NULL);
>  	/* Ignore read errors and empty reads. */
>  	if (XENBUS_IS_ERR_READ(str)) {
>  		xenbus_transaction_end(xbt, 1);
>   

