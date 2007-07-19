Return-Path: <linux-kernel-owner+w=401wt.eu-S965966AbXGSTot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965966AbXGSTot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932190AbXGSTok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:44:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:29881 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764753AbXGSToi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=t5xFVCHwZI2J7d7AQuq4u8eD1zc/2fJ9OJXvqLQIxwXW7B7pBYL/k/5qc02CH9diWRhW7r9qOgJHM7RaUUYDyRC0Pzd8IPE427Y/VfbwCqoWOnzu7fnb4YOGqOEEJbO+WvXNmUVQIhHCvqNjJuHKpfWVmROAFYSP/iyFyEwPRx8=
Date: Thu, 19 Jul 2007 23:44:34 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@osdl.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Update .gitignore for arch/i386/boot
Message-ID: <20070719194434.GB6524@martell.zuzino.mipt.ru>
References: <20070719190910.GX14791@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719190910.GX14791@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 01:09:10PM -0600, Matthew Wilcox wrote:
> With the new setup code, we generate a couple more files

> --- a/arch/i386/boot/.gitignore
> +++ b/arch/i386/boot/.gitignore
> @@ -1,3 +1,5 @@
>  bootsect
>  bzImage
>  setup
> +setup.bin
> +setup.elf

ACK

same chunk against arch/x86_64/boot/.gitignore

--- a/arch/x86_64/boot/.gitignore
+++ b/arch/x86_64/boot/.gitignore
@@ -1,3 +1,5 @@
 bootsect
 bzImage
 setup
+setup.bin
+setup.elf

