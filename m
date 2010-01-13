Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251Ab0AMFcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab0AMFcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 00:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402Ab0AMFcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 00:32:50 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:35641 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab0AMFct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 00:32:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=D+UTi/MEjqK9A5yWtVpQhRpSOItPLABf/UDnFXnbp5ebrZ3a1kLzuseCowrcEad6bt
         BolXkW7ImjY/5x9Qv2GImTscS1OKp14rrpNJuNxdLgLSwsFIfaUyMYq2FIVkSw4OM+pe
         Ep6CQ6j6rGgcNXxLAR7G+2N9L1aeuO5N8t1uU=
Subject: Re: [PATCH]drivers/mtd/chips/cfi_probe.c:18 remove unneeded comment
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: =?ISO-8859-1?Q?Ren=E9?= Bolldorf <xsecute@googlemail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
In-Reply-To: <4B465DA1.6010300@googlemail.com>
References: <4B465DA1.6010300@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 07:32:45 +0200
Message-Id: <1263360765.3445.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 23:18 +0100, René Bolldorf wrote:
> --- ./drivers/mtd/chips/cfi_probe.c     2009-12-28 21:09:46.638828686 +0100
> +++ ./drivers/mtd/chips/cfi_probe.c     2010-01-04 22:38:31.536678726 +0100
> @@ -18,8 +18,6 @@
>   #include <linux/mtd/cfi.h>
>   #include <linux/mtd/gen_probe.h>
> 
> -//#define DEBUG_CFI
> -
>   #ifdef DEBUG_CFI
>   static void print_cfi_ident(struct cfi_ident *);
>   #endif

I do not think this is is needed. The commented out define shows what
one should do to debug the thing. Without that line it is not so
obvious. So, nack from me.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

