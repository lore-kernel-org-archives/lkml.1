Return-Path: <linux-kernel-owner+w=401wt.eu-S934918AbYBABCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934918AbYBABCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 20:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbYBABCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 20:02:31 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:46612 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbYBABCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:02:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cSp57JvjFSzO1MJV7tI15CuqPta0o4RIcDrkDYeAxjGTT+7F3uBnY09YjDvDC5LHzPpvLJD1Vy/r0i3bcFiFlHT+UlaVdXXN8EFjcLyBzt6nKDOOw0fCJ7Gmn+x3uN7UBDfPrMioyJ7IlLLsXRQfdxFrc6IKHJf1d4ZctZSY6RQ=
Message-ID: <86802c440801311702i1ac94b0m2af0bcdec6c9e866@mail.gmail.com>
Date: Thu, 31 Jan 2008 17:02:29 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: kill misleading comments in trampoline_*.S
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080201005429.GA5085@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080201005429.GA5085@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 4:54 PM, Pavel Machek <pavel@ucw.cz> wrote:
>
>
> Both trampolines actually *do* set up stack. (Is the "we jump into
> compressed/head.S" comment still true?)
>
> Signed-off-by: Pavel Machek <pavel@suse.cz>
>
> diff --git a/arch/x86/kernel/trampoline_32.S b/arch/x86/kernel/trampoline_32.S
> index 9bcc1c6..5398547 100644
> --- a/arch/x86/kernel/trampoline_32.S
> +++ b/arch/x86/kernel/trampoline_32.S
> @@ -11,9 +11,6 @@
>   *     trampoline page to make our stack and everything else
>   *     is a mystery.
>   *
> - *     In fact we don't actually need a stack so we don't
> - *     set one up.
> - *
>   *     We jump into the boot/compressed/head.S code. So you'd
>   *     better be running a compressed kernel image or you
>   *     won't get very far.

should be arch/x86/kernel/head_32.S

YH
