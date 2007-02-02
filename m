Return-Path: <linux-kernel-owner+w=401wt.eu-S1423215AbXBBICq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423215AbXBBICq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 03:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423216AbXBBICq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 03:02:46 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:40774 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423215AbXBBICp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 03:02:45 -0500
Date: Fri, 2 Feb 2007 13:32:40 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Judith Lebzelter <judith@osdl.org>
Cc: linux-kernel@vger.kernel.org, fastboot@osdl.org, ebiederm@xmission.com,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [Fastboot] [ PATCH ] fix to documentation for kexec
Message-ID: <20070202080240.GC6353@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070201181955.GE5825@shell0.pdx.osdl.net> <Pine.LNX.4.61.0702011923530.13737@yvahk01.tjqt.qr> <Pine.LNX.4.64.0702011329550.16875@CPE00045a9c397f-CM001225dbafb6> <Pine.LNX.4.61.0702011932090.13737@yvahk01.tjqt.qr> <20070201184217.GF5825@shell0.pdx.osdl.net> <20070201185808.GG5825@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201185808.GG5825@shell0.pdx.osdl.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 10:58:08AM -0800, Judith Lebzelter wrote:
> > 
> > I did notice that my patch is out of date for the latest kernel, 
> > however.  I can send an up to date one.
> > 
> This applies to 2.6.20-rc7
> 
> Signed-off-by: Judith Lebzeelter <judith@osdl.org>
> ---
> 
> Stop recommending incorrect/superfluous "init" boot parameter.
> 

This looks good. The intention here is just to boot into run level 1, so
that minimum scripts run in user space and probability of capturing the
dump increases.

Fedora doc does say that appending "1" on command line will boot it
into runlevel 1. I hope same is true for other distributions too.

Thanks
Vivek

> Index: linux-2.6.20-rc7/Documentation/kdump/kdump.txt
> ===================================================================
> --- linux-2.6.20-rc7.orig/Documentation/kdump/kdump.txt
> +++ linux-2.6.20-rc7/Documentation/kdump/kdump.txt
> @@ -311,10 +311,10 @@ Following are the arch specific command 
>  loading dump-capture kernel.
>  
>  For i386, x86_64 and ia64:
> -	"init 1 irqpoll maxcpus=1"
> +	"1 irqpoll maxcpus=1"
>  
>  For ppc64:
> -	"init 1 maxcpus=1 noirqdistrib"
> +	"1 maxcpus=1 noirqdistrib"
>  
>  
>  Notes on loading the dump-capture kernel:
> @@ -332,8 +332,8 @@ Notes on loading the dump-capture kernel
>  * You must specify <root-dev> in the format corresponding to the root
>    device name in the output of mount command.
>  
> -* "init 1" boots the dump-capture kernel into single-user mode without
> -  networking. If you want networking, use "init 3."
> +* Boot parameter "1" boots the dump-capture kernel into single-user 
> +  mode without networking. If you want networking, use "3".
>  
>  * We generally don' have to bring up a SMP kernel just to capture the
>    dump. Hence generally it is useful either to build a UP dump-capture
> _______________________________________________
> fastboot mailing list
> fastboot@lists.osdl.org
> https://lists.osdl.org/mailman/listinfo/fastboot
