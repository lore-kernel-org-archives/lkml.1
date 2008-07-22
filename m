Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbYGVNGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbYGVNGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbYGVNF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:05:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:26506 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYGVNFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:05:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jsMkMRgiaaeFT/oBb/MZf2AcFIQzvD6S+EaVISY6nPO5Y+JznZlNpNEPBus1c++1AY
         zaICsTBGGqxs+NLVFuiT2JtR9mYaPanhE7EBYiLTa0l1NI+eADUde3tTKLP5m6dGPUK4
         WsKFjfXOlW7nk1kTKGlmFmx+EnmaL6dSKIy5c=
Message-ID: <524f69650807220605w4ec533d9y59eab099913caa2f@mail.gmail.com>
Date: Tue, 22 Jul 2008 08:05:53 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] cifs: fix compiler warning on 64-bit arch-s
Cc: sfrench@samba.org, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4880A5A9.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4880A5A9.76E4.0078.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged into cifs-2.6.git

On Fri, Jul 18, 2008 at 7:16 AM, Jan Beulich <jbeulich@novell.com> wrote:
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>
> ---
>  fs/cifs/asn1.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-2.6.26/fs/cifs/asn1.c 2008-07-13 23:51:29.000000000 +0200
> +++ 2.6.26-cifs-warning/fs/cifs/asn1.c  2008-07-17 15:23:11.000000000 +0200
> @@ -400,7 +400,7 @@ asn1_oid_decode(struct asn1_ctx *ctx,
>        size = eoc - ctx->pointer + 1;
>
>        /* first subid actually encodes first two subids */
> -       if (size < 2 || size > ULONG_MAX/sizeof(unsigned long))
> +       if (size < 2 || size > UINT_MAX/sizeof(unsigned long))
>                return 0;
>
>        *oid = kmalloc(size * sizeof(unsigned long), GFP_ATOMIC);
>
>
>
>



-- 
Thanks,

Steve
