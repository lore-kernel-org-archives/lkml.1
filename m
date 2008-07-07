Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbYGGVlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbYGGVlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbYGGVl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:41:26 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:41753 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbYGGVl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:41:26 -0400
Date: Mon, 7 Jul 2008 22:41:54 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] FS: Label tmpfs Kconfig option with "tmpfs".
In-Reply-To: <alpine.LFD.1.10.0807071517090.29975@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0807072231160.1608@blonde.site>
References: <alpine.LFD.1.10.0807071517090.29975@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008, Robert P. J. Day wrote:
> 
> Make it clear that the Kconfig option refers to "tmpfs".
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

It's so long since I used anything but "make oldconfig", which
already shows TMPFS, making your mod seem redundant.  But you're right,
menuconfig and xconfig don't show it, so your change is a good one.

Though for the moment I can only give you
acked-by: hugh dickins <hugh@veritas.com>:
the next entry is for "Tmpfs POSIX Access Control Lists"
so I'd rather you say "Tmpfs support (virtual memory file system)",
then you can uppercase my ack.

hugh

> 
> ---
> 
>   if people haven't yet figured out that this used to be shm fs, they
> probably don't need to know.
> 
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 2694648..9360b69 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -979,7 +979,7 @@ config SYSFS
>  	Designers of embedded systems may wish to say N here to conserve space.
> 
>  config TMPFS
> -	bool "Virtual memory file system support (former shm fs)"
> +	bool "tmpfs support (Virtual memory file system)"
>  	help
>  	  Tmpfs is a file system which keeps all files in virtual memory.
>  
