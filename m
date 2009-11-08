Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbZKHNi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbZKHNi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbZKHNi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:38:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:42928 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZKHNi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:38:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=wAzx/u5DnsknRu1V91mCCQj3q6D2a1KR68sF0cg3DydOrKWX2T0rWBIO+KtBuUwfd+
         7jZkuicguk+UTZWjrb5H5xaAY6X0LWGQK7AQFVHLRDSNWdD/bGihwddlEGwhOAivRKpS
         mLuykHFKkILHOYaaGzLjrI5e5G4WK3dAAb/40=
Message-ID: <4AF6C9D7.8060004@gmail.com>
Date: Sun, 08 Nov 2009 14:38:31 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/75] cyclades: declare MODULE_FIRMWARE
References: <1257630121.15927.383.camel@localhost>
In-Reply-To: <1257630121.15927.383.camel@localhost>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2009 10:42 PM, Ben Hutchings wrote:
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Reviewed-by: Jiri Slaby <jirislaby@gmail.com>

> ---
>  drivers/char/cyclades.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
> index 4254457..0113574 100644
> --- a/drivers/char/cyclades.c
> +++ b/drivers/char/cyclades.c
> @@ -4208,3 +4208,4 @@ module_exit(cy_cleanup_module);
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(CY_VERSION);
>  MODULE_ALIAS_CHARDEV_MAJOR(CYCLADES_MAJOR);
> +MODULE_FIRMWARE("cyzfirm.bin");

