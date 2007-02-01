Return-Path: <linux-kernel-owner+w=401wt.eu-S1422873AbXBAS0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422873AbXBAS0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 13:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422915AbXBAS0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 13:26:40 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:52286 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422873AbXBAS0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 13:26:39 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 1 Feb 2007 13:25:04 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Judith Lebzelter <judith@osdl.org>
cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, fastboot@osdl.org
Subject: Re: [ PATCH ] fix to documentation for kexec
In-Reply-To: <20070201181955.GE5825@shell0.pdx.osdl.net>
Message-ID: <Pine.LNX.4.64.0702011324050.16833@CPE00045a9c397f-CM001225dbafb6>
References: <20070201181955.GE5825@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007, Judith Lebzelter wrote:

> Hello,
>
> I've noticed that the boot options are not correct for in
> the documentation for kdump. The "init" keyword is not
> necessary, and causes a kernel panic when booting with an
> initrd on Fedora 5.
>
> Thanks;
> Judith Lebzelter
>
> ---
> Signed-off-by: Judith Lebzelter <judith@osdl.org>
> ---
>
>
> Index: linux/Documentation/kdump/kdump.txt
> ===================================================================
> --- linux.orig/Documentation/kdump/kdump.txt
> +++ linux/Documentation/kdump/kdump.txt
> @@ -207,7 +207,7 @@ the following command:
>
>     kexec -p <dump-capture-kernel> \
>     --initrd=<initrd-for-dump-capture-kernel> --args-linux \
> -   --append="root=<root-dev> init 1 irqpoll"
> +   --append="root=<root-dev> 1 irqpoll"
>
>
>  Notes on loading the dump-capture kernel:
> @@ -228,8 +228,8 @@ Notes on loading the dump-capture kernel
>  * You must specify <root-dev> in the format corresponding to the root
>    device name in the output of mount command.
>
> -* "init 1" boots the dump-capture kernel into single-user mode without
> -  networking. If you want networking, use "init 3."
> +* Boot parameter "1" boots the dump-capture kernel into single-user mode
> +  without networking. If you want networking, use "3".

i'm not sure you want to totally remove those first two lines, they
appear to talk about getting to run level 1 *from a running system*.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
