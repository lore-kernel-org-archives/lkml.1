Return-Path: <linux-kernel-owner+w=401wt.eu-S1751299AbZKKFRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbZKKFRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 00:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbZKKFRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 00:17:17 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:46432 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbZKKFRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 00:17:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Zt2kXzyEqVDiQVIBBmnawciy+F4hkoSTlO9NckbQkZl8PnpiEvKEhOuGFwrUjq/Vkc
         7PtOIR4QlBmLQOaQiJUOvGgTXsTcKhVkmekgvfLENHRIrhMS7v4NW3wcjruDWtUQcps6
         BoIbemdLqKYWl2uYXV3wqqDTjYZDx3roLhh3I=
MIME-Version: 1.0
In-Reply-To: <4AF9FB6C.70003@oracle.com>
References: <4AF9FB6C.70003@oracle.com>
Date: Wed, 11 Nov 2009 13:17:22 +0800
Message-ID: <2375c9f90911102117q33f7ce4raed39f960ddcf1fc@mail.gmail.com>
Subject: Re: [PATCH] x86 VSDO: fix Kconfig help
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, x86@kernel.org,
       linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 7:46 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> COMPAT_VDSO has 2 help text blocks, but kconfig only uses the
> last one found, so merge the 2 blocks.
>
> It would be real nice if kconfig would warn about this.
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Looks good.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!

> ---
>  arch/x86/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- lnx-2632-rc6.orig/arch/x86/Kconfig
> +++ lnx-2632-rc6/arch/x86/Kconfig
> @@ -1601,12 +1601,12 @@ config COMPAT_VDSO
>        prompt "Compat VDSO support"
>        depends on X86_32 || IA32_EMULATION
>        ---help---
> -         Map the 32-bit VDSO to the predictable old-style address too.
> -       ---help---
>          Say N here if you are running a sufficiently recent glibc
>          version (2.3.3 or later), to remove the high-mapped
>          VDSO mapping and to exclusively use the randomized VDSO.
>
> +         Map the 32-bit VDSO to the predictable old-style address too.
> +
>          If unsure, say Y.
>
>  config CMDLINE_BOOL
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
