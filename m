Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbYJ1DcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbYJ1DcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 23:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYJ1Dbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 23:31:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:39645 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYJ1Dbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 23:31:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=S+Y1nd+w3Nv2sWFpjAnJ/pSb6SmrLmNdWu1ajdHJAsIfCr2SS+LyV3SRW+XbfYMPlU
         BCZ4J1xj4nl1hSg28ZVcdDYzA4ksMUpfI8ExEZ2vvQjXlPMVi7EQ43v0aKs9eq5Js59U
         QrQ/o2K/U9nYWd1alzdnfihOTVsc9887GR4mc=
Message-ID: <1aad82fa0810272031p3ab3bc1bn3b6295abe8b218ae@mail.gmail.com>
Date: Mon, 27 Oct 2008 23:31:50 -0400
From: "Mike Frysinger" <vapier@gentoo.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] linux/timex.h: cleanup for userspace
Cc: "Roman Zippel" <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081027202827.30e6c038.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225017451-19133-1-git-send-email-vapier@gentoo.org>
	 <20081027202827.30e6c038.akpm@linux-foundation.org>
X-Google-Sender-Auth: 15022417f7100b2f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 11:28 PM, Andrew Morton wrote:
> On Sun, 26 Oct 2008 06:37:31 -0400 Mike Frysinger wrote:
>> Move all the kernel-specific defines and includes into the __KERNEL__
>> section so that they don't get leaked into userspace.
>
> checkpatch correctly instructs us to use linux/param.h, not asm/param.h.

i was just moving around existing code in an attempt to minimize
possible breakage ;)

> --- a/include/linux/timex.h~linux-timexh-cleanup-for-userspace-checkpatch-fixes
> +++ a/include/linux/timex.h
> @@ -165,8 +165,8 @@ struct timex {
>  #ifdef __KERNEL__
>  #include <linux/compiler.h>
>  #include <linux/types.h>
> +#include <linux/param.h>
>
> -#include <asm/param.h>
>  #include <asm/timex.h>
>
>  /*
> _
>
> seems Obviously Safe to me.  Do you agree?

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
-mike
