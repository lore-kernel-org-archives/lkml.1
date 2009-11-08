Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZKHNcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZKHNcC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:32:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZKHNcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:32:01 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65328 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbZKHNcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:32:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=MuZEoiyVuOEwxWR/8Qatl559hh5zV1TccB2oyzLziGPa91sLtJGPVK/kQHes3ioKGb
         TTNvOCsTZyhkCNPKktFQDha92CA8b64SVnkDX2ff+IymZGEN1Fr6m9KRpXWS+T9c5C0W
         ktjyvcWqa3Mg/Ue2YaBqRbYP9drHwjdZ8ChxU=
Message-ID: <4AF6C852.8040306@gmail.com>
Date: Sun, 08 Nov 2009 14:32:02 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/75] isicom: declare MODULE_FIRMWARE
References: <1257630239.15927.389.camel@localhost>
In-Reply-To: <1257630239.15927.389.camel@localhost>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2009 10:43 PM, Ben Hutchings wrote:
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Reviewed-by: Jiri Slaby <jirislaby@gmail.com>

> ---
>  drivers/char/isicom.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
> index 426bfdd..1da1372 100644
> --- a/drivers/char/isicom.c
> +++ b/drivers/char/isicom.c
> @@ -1782,3 +1782,8 @@ module_exit(isicom_exit);
>  MODULE_AUTHOR("MultiTech");
>  MODULE_DESCRIPTION("Driver for the ISI series of cards by MultiTech");
>  MODULE_LICENSE("GPL");
> +MODULE_FIRMWARE("isi608.bin");
> +MODULE_FIRMWARE("isi608em.bin");
> +MODULE_FIRMWARE("isi616em.bin");
> +MODULE_FIRMWARE("isi4608.bin");
> +MODULE_FIRMWARE("isi4616.bin");

