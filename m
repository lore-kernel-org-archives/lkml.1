Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbZKPG00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbZKPG00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 01:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZKPG0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 01:26:25 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:38435 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbZKPG0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 01:26:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jJKbXbiaC/hFULWQvMYMXLO5hsJPkIPmQ2HWlqLhFmlaEZeTY1Te8c802EaTwGjYSW
         VcJH1Xm5Y2LGkj0P0pwQYc4Yn48Tfa+pSlxvkjFZbbjx3NOhXZwVfrImlmu1ZKy2wFe+
         Dhv9NH5xo5kNho/EkJr0gcm1EUOVKG0ODJS58=
MIME-Version: 1.0
In-Reply-To: <1258350595-19285-1-git-send-email-wenji.huang@oracle.com>
References: <1258350595-19285-1-git-send-email-wenji.huang@oracle.com>
Date: Mon, 16 Nov 2009 14:26:29 +0800
Message-ID: <2375c9f90911152226o5eda512dia6adbb7ec4445d45@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: clean up marker
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Wenji Huang <wenji.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 1:49 PM, Wenji Huang <wenji.huang@oracle.com> wrote:
> Drop Module.markers from cleaning list.
>
> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Cc: Sam Ravnborg <sam@ravnborg.org>

> ---
>  Makefile |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 8278361..1c8c3e1 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1198,7 +1198,7 @@ MRPROPER_FILES += .config .config.old include/asm .version .old_version \
>                   include/linux/autoconf.h include/linux/version.h      \
>                   include/linux/utsrelease.h                            \
>                   include/linux/bounds.h include/asm*/asm-offsets.h     \
> -                 Module.symvers Module.markers tags TAGS cscope*
> +                 Module.symvers tags TAGS cscope*
>
>  # clean - Delete most, but leave enough to build external modules
>  #
> @@ -1217,7 +1217,7 @@ clean: archclean $(clean-dirs)
>                \( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
>                -o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
>                -o -name '*.symtypes' -o -name 'modules.order' \
> -               -o -name 'Module.markers' -o -name '.tmp_*.o.*' \
> +               -o -name '.tmp_*.o.*' \
>                -o -name '*.gcno' \) -type f -print | xargs rm -f
>
>  # mrproper - Delete all generated files, including .config
> @@ -1415,7 +1415,6 @@ $(clean-dirs):
>
>  clean: rm-dirs := $(MODVERDIR)
>  clean: rm-files := $(KBUILD_EXTMOD)/Module.symvers \
> -                   $(KBUILD_EXTMOD)/Module.markers \
>                    $(KBUILD_EXTMOD)/modules.order
>  clean: $(clean-dirs)
>        $(call cmd,rmdirs)
> --
> 1.5.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
