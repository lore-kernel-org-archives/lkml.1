Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780Ab0ADWcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0ADWcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628Ab0ADWcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:32:10 -0500
Received: from xenotime.net ([72.52.64.118]:36783 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753481Ab0ADWcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:32:09 -0500
Date: Mon, 4 Jan 2010 14:32:25 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH/resend] Document awk requirements
Message-Id: <20100104143225.64a20bea.rdunlap@xenotime.net>
In-Reply-To: <20100104221345.GA7897@nb-core2.darkstar.lan>
References: <20100104221345.GA7897@nb-core2.darkstar.lan>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010 23:13:45 +0100 Luca Tettamanti wrote:

> Gnu awk is required for generating generating
> arch/x86/lib/inat-tables.c:
> 
>  GEN     arch/x86/lib/inat-tables.c
>  Error: Your awk doesn't support charactor-class.
> 
> mawk doesn't work anymore.

Hi,
Did you try this patch?

Subject: [tip:x86/urgent] x86: Don't use POSIX character classes in gen-insn-attr-x86.awk


> Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
> Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
> Hum, who is in charge of the documentation?

It depends on which documentation.  I am for some of it.
GregKH for some of it.  Other people for other parts of it.

But for this one, I could merge it, but I think that it's not needed
due to the patch that I mentioned above.  If your patch is still
needed, Andrew or I can merge it.



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


---
~Randy
