Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbZKHNcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbZKHNcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZKHNcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:32:22 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65328 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbZKHNcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:32:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=MHLsWDmZ0Zj6A224kwNLqZD+kcZcqxCF9ARhjEaUl5WNdoLQIO8z34lfjWaFjopoub
         o1X9odmlos3Ya6t8eRuLR+7vhI+gUzhcQv2qMQc64yz5gX7EzerDHRZnMoCqjcMPjHHJ
         edf6Qnw1Hfz6GiqOrMVIpghDU25PnqwRDVvw8=
Message-ID: <4AF6C869.7090309@gmail.com>
Date: Sun, 08 Nov 2009 14:32:25 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/75] moxa: declare MODULE_FIRMWARE
References: <1257630292.15927.392.camel@localhost>
In-Reply-To: <1257630292.15927.392.camel@localhost>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2009 10:44 PM, Ben Hutchings wrote:
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Reviewed-by: Jiri Slaby <jirislaby@gmail.com>

Thanks.

> ---
>  drivers/char/moxa.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
> index dd0083b..26c9259 100644
> --- a/drivers/char/moxa.c
> +++ b/drivers/char/moxa.c
> @@ -175,6 +175,9 @@ static unsigned int numports[MAX_BOARDS];
>  MODULE_AUTHOR("William Chen");
>  MODULE_DESCRIPTION("MOXA Intellio Family Multiport Board Device Driver");
>  MODULE_LICENSE("GPL");
> +MODULE_FIRMWARE("c218tunx.cod");
> +MODULE_FIRMWARE("cp204unx.cod");
> +MODULE_FIRMWARE("c320tunx.cod");
>  #ifdef MODULE
>  module_param_array(type, uint, NULL, 0);
>  MODULE_PARM_DESC(type, "card type: C218=2, C320=4");

