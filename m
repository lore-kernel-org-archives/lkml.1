Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbZGXJW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbZGXJW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 05:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZGXJW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 05:22:56 -0400
Received: from mail-pz0-f192.google.com ([209.85.222.192]:46868 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbZGXJWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 05:22:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lJA2qUeiSsnCLxwyF9PhNTHlbWbFQYG1/QhPpEMLkjPhoQBaaSevAs7cYQwMLOBx2t
         uyVZNpndOVKYtLjruTUuC+qeBnkNJ4a+2lDPkvjyqx4WKhyAI+sQbEfIh55MvFn/WaM2
         XZDb0ICxWy9iy3XgSfxyEQddRodnAsVvmRah0=
Date: Fri, 24 Jul 2009 17:25:05 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Trevor Pace <trevorpace@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: PATCH: Removed useless variable in arch/x86/boot/tty.c puts()
Message-ID: <20090724092505.GD6372@cr0.nay.redhat.com>
References: <bad58e960907221751h4520c359u47b29edd77f02db1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bad58e960907221751h4520c359u47b29edd77f02db1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 09:51:28PM -0300, Trevor Pace wrote:
>Change: Removed needless counting integer.
>
>Applies to kernel version 2.6.30.2.
>

This was already done by HPA, please check the latest Linus tree.

Thanks.


>Signed-off-by: Trevor Pace <tr212206@dal.ca>
>
>=====================================================================
>
>--- arch/x86/boot/tty.c	2009-07-22 19:59:33.000000000 -0300
>+++ arch/x86/boot/tty.c	2009-07-22 21:37:25.000000000 -0300
>@@ -35,11 +35,8 @@ void __attribute__((section(".inittext")
>
> void __attribute__((section(".inittext"))) puts(const char *str)
> {
>-	int n = 0;
>-	while (*str) {
>+	while (*str)
> 		putchar(*str++);
>-		n++;
>-	}
> }
>
> /*
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
