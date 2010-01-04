Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074Ab0ADWk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab0ADWk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961Ab0ADWk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:40:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab0ADWkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:40:55 -0500
Message-ID: <4B426E75.6060706@redhat.com>
Date: Mon, 04 Jan 2010 17:40:53 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/resend] Document awk requirements
References: <20100104221345.GA7897@nb-core2.darkstar.lan>
In-Reply-To: <20100104221345.GA7897@nb-core2.darkstar.lan>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luca,

As Randy said, gen-insn-attr-x86.awk doesn't need gawk anymore,

> Subject: [tip:x86/urgent] x86: Don't use POSIX character classes in gen-insn-attr-x86.awk

because above patch removes POSIX character classes.
So I think we don't need to update Documentation/Changes.

Thank you,


Luca Tettamanti wrote:
> Gnu awk is required for generating generating
> arch/x86/lib/inat-tables.c:
> 
>  GEN     arch/x86/lib/inat-tables.c
>  Error: Your awk doesn't support charactor-class.
> 
> mawk doesn't work anymore.
> 
> Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
> Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
> Hum, who is in charge of the documentation?
> Masami can you push it?
> 
>  Documentation/Changes |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/Changes b/Documentation/Changes
> index f08b313..abec6f2 100644
> --- a/Documentation/Changes
> +++ b/Documentation/Changes
> @@ -50,6 +50,7 @@ o  udev                   081                     # udevinfo -V
>  o  grub                   0.93                    # grub --version
>  o  mcelog		  0.6
>  o  iptables               1.4.1                   # iptables -V
> +o  Gnu awk                3.1.5                   # awk --version
>  
>  
>  Kernel compilation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

