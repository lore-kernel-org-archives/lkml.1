Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbYFXXTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbYFXXTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 19:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYFXXT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 19:19:27 -0400
Received: from xenotime.net ([66.160.160.81]:44624 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753100AbYFXXT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 19:19:26 -0400
Date: Tue, 24 Jun 2008 16:19:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Vivek Goyal <vgoyal@in.ibm.com>, Maneesh Soni <maneesh@in.ibm.com>
Subject: Re: [Patch] Documentation/kdump/kdump.txt: fix some words
Message-Id: <20080624161925.422c1929.rdunlap@xenotime.net>
In-Reply-To: <20080624133355.GA10512@hack.voiplan.pt>
References: <20080624133355.GA10512@hack.voiplan.pt>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 14:33:55 +0100 WANG Cong wrote:

> 
> This is a trivial patch that only fixes mistakes in
> Documentation/kdump/kdump.txt.
> 
> Signed-off-by: WANG Cong <wangcong@zeuux.org>
> Cc: Randy Dunlap <rdunlap@xenotime.net>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> Cc: Vivek Goyal <vgoyal@in.ibm.com>
> Cc: Maneesh Soni <maneesh@in.ibm.com>
> 
> ---
> diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
> index b8e52c0..0ffa90c 100644
> --- a/Documentation/kdump/kdump.txt
> +++ b/Documentation/kdump/kdump.txt
> @@ -108,15 +108,15 @@ There are two possible methods of using Kdump.
>  
>  2) Or use the system kernel binary itself as dump-capture kernel and there is
>     no need to build a separate dump-capture kernel. This is possible
> -   only with the architecutres which support a relocatable kernel. As
> -   of today i386 and ia64 architectures support relocatable kernel.
> +   only for the architectures which support a relocatable kernel. As
> +   of today i386 and ia64 architectures support a relocatable kernel.
>  
>  Building a relocatable kernel is advantageous from the point of view that
>  one does not have to build a second kernel for capturing the dump. But
>  at the same time one might want to build a custom dump capture kernel
>  suitable to his needs.
>  
> -Following are the configuration setting required for system and
> +Following are the configuration settings required for system and
>  dump-capture kernels for enabling kdump support.
>  
>  System kernel config options
> @@ -299,14 +299,14 @@ For ia64:
>  	- Use vmlinux or vmlinuz.gz
>  
>  
> -If you are using a uncompressed vmlinux image then use following command
> +If you are using an uncompressed vmlinux image then use the following command
>  to load dump-capture kernel.
>  
>     kexec -p <dump-capture-kernel-vmlinux-image> \
>     --initrd=<initrd-for-dump-capture-kernel> --args-linux \
>     --append="root=<root-dev> <arch-specific-options>"
>  
> -If you are using a compressed bzImage/vmlinuz, then use following command
> +If you are using a compressed bzImage/vmlinuz, then use the following command
>  to load dump-capture kernel.
>  
>     kexec -p <dump-capture-kernel-bzImage> \
> @@ -315,7 +315,7 @@ to load dump-capture kernel.
>  
>  Please note, that --args-linux does not need to be specified for ia64.
>  It is planned to make this a no-op on that architecture, but for now
> -it should be omitted
> +it should be omitted.
>  
>  Following are the arch specific command line options to be used while
>  loading dump-capture kernel.
> @@ -347,7 +347,7 @@ Notes on loading the dump-capture kernel:
>  * Boot parameter "1" boots the dump-capture kernel into single-user
>    mode without networking. If you want networking, use "3".
>  
> -* We generally don' have to bring up a SMP kernel just to capture the
> +* We generally don't have to bring up a SMP kernel just to capture the
>    dump. Hence generally it is useful either to build a UP dump-capture
>    kernel or specify maxcpus=1 option while loading dump-capture kernel.
>  
> 


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
