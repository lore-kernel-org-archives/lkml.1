Return-Path: <linux-kernel-owner+w=401wt.eu-S932372AbXBNQeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbXBNQeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 11:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932375AbXBNQeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 11:34:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:17786 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372AbXBNQeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 11:34:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YrzSPIxI+U92j2QXKcb7J+9Xhiuw6Rjm7Symm/98k6s7+qwSO3DhS2o6a7mevw31L1LLroUl6TclWy1+bYSzycl98xBAmmxNNIxxkgL4GQsR+Qi5/bysKGkeTYaMAmS3ZjaqjaF3q8N4VGg/gzKA2JuuvzT3XxHBo4UYluAqW/M=
Message-ID: <40f323d00702140833p36502b7dq198d5774224390ec@mail.gmail.com>
Date: Wed, 14 Feb 2007 17:33:59 +0100
From: "Benoit Boissinot" <bboissin@gmail.com>
To: "Thibaud Hulin" <hulin.thibaud@wanadoo.fr>
Subject: Re: no swap!
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45D335A2.5080105@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45D335A2.5080105@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/14/07, Thibaud Hulin <hulin.thibaud@wanadoo.fr> wrote:
> Hi !

distro related: check
https://bugs.launchpad.net/ubuntu/+source/util-linux/+bug/66637 and
all the duplicates


>
> After compiling the kernel, I discover that my computer don't use the swap.
> So, I try a cat .config |grep SW, and I got :
> CONFIG_SWAP=y
> # CONFIG_X86_VISWS is not set
> CONFIG_X86_BSWAP=y
> CONFIG_SUSPEND2_SWAP=y
> CONFIG_SUSPEND2_REPLACE_SWSUSP=y
> # CONFIG_AGP_SWORKS is not set
> CONFIG_USB_AUERSWALD=m
>
> This is my fstab :
> # /etc/fstab: static file system information.
> #
> # <file system> <mount point>   <type>  <options>       <dump>  <pass>
> proc            /proc           proc    defaults        0       0
> # /dev/hda1 -- converted during upgrade to edgy
> UUID=c0808eb9-790a-4a20-a3a2-26a4204d0fb2 / ext3
> defaults,errors=remount-ro 0 1
> # /dev/hda5 -- converted during upgrade to edgy
> UUID=dfcca30e-3b78-4110-b578-9b8835ecf062 none swap sw 0 0
> #/dev/hda5      none    swap    sw      0       0
> /dev/hdc        /media/cdrom0   udf,iso9660 user,noauto     0       0
> /dev/fd0        /media/floppy0  auto    rw,user,noauto  0       0
>
>
> Is it a problem of LVM or RAID ? I don't understand that very well...
>
