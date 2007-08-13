Return-Path: <linux-kernel-owner+w=401wt.eu-S942815AbXHMMoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942815AbXHMMoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965812AbXHMHW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:22:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:10870 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965728AbXHMHWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:22:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BwbZur0S+ZTNNFCLv3VBwRDqJymVnGmE+x7HFwYOTWFLt/BmwkDN0oC85869sFxEzOlPucL6AIozHuhbU7I/1u8nWUmsF3pODCL3lifn36CHjn3SZNMd3kGJqXFUszA+wb0SYvllM4DzwQwq0fIbV4DN3fZIHqBWy1M8nmD8gPQ=
Message-ID: <de88ba480708130022y1cc9b9a7ucbaf376a572e0f4e@mail.gmail.com>
Date: Mon, 13 Aug 2007 16:22:49 +0900
From: "Masanori Goto" <gotom@sanori.org>
To: "joe@perches.com" <joe@perches.com>
Subject: Re: [PATCH] [347/2many] MAINTAINERS - NINJA SCSI-32Bi/UDE PCI/CARDBUS SCSI HOST ADAPTER DRIVER
Cc: yokota@netlab.is.tsukuba.ac.jp, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       gotom@sanori.org
In-Reply-To: <46bffb18.d2jtcobSM4uNoxbu%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bffb18.d2jtcobSM4uNoxbu%joe@perches.com>
X-Google-Sender-Auth: 5a901442af273d28
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/13, joe@perches.com <joe@perches.com>:
> Add file pattern to MAINTAINER entry
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6f7fc81..378ad04 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3339,6 +3339,8 @@ P:        YOKOTA Hiroshi
>  M:     yokota@netlab.is.tsukuba.ac.jp
>  W:     http://www.netlab.is.tsukuba.ac.jp/~yokota/izumi/ninja/
>  S:     Maintained
> +F:     Documentation/scsi/NinjaSCSI.txt
> +F:     drivers/scsi/pcmcia/nsp_*

There are two variants of Ninja SCSI driver.

- NINJA SCSI-3 / NINJA SCSI-32Bi (16bit/CardBus) PCMCIA SCSI HOST ADAPTER DRIVER
 +F:     Documentation/scsi/NinjaSCSI.txt
 +F:     drivers/scsi/pcmcia/nsp_*

- NINJA SCSI-32Bi/UDE PCI/CARDBUS SCSI HOST ADAPTER DRIVER
 +F:     drivers/scsi/nsp32*

Could you take a look at them again?

Thanks,
-- gotom
