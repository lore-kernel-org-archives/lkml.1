Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbXEXXLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbXEXXLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbXEXXLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:11:47 -0400
Received: from terminus.zytor.com ([192.83.249.54]:47985 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbXEXXLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:11:46 -0400
Message-ID: <46561AA5.8090908@zytor.com>
Date: Thu, 24 May 2007 16:07:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jacques Gelinas <jacques@solucorp.qc.ca>,
       Matija Nalis <mnalis@jagor.srce.hr>, Matija Nalis <mnalis@voyager.hr>,
       trivial@kernel.org
Subject: Re: [PATCH] Remove a few UMSDOS leftovers
References: <200705250058.29266.jesper.juhl@gmail.com>
In-Reply-To: <200705250058.29266.jesper.juhl@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> The UMSDOS filesystem was removed back in 2.6.11, but some tiny bits 
> stuck around. This patch removes the few leftovers.
> The only things left behind after this are the entries in the CREDITS file.
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> --- 
> 
>  Documentation/ioctl-number.txt |    1 -
>  arch/arm26/defconfig           |    1 -
>  arch/cris/arch-v10/defconfig   |    1 -
>  arch/um/config.release         |    1 -
>  include/linux/ncp_fs.h         |    2 --
>  5 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/ioctl-number.txt b/Documentation/ioctl-number.txt
> index 3de7d37..f9f15bf 100644
> --- a/Documentation/ioctl-number.txt
> +++ b/Documentation/ioctl-number.txt
> @@ -67,7 +67,6 @@ Code	Seq#	Include File		Comments
>  0x00	00-1F	linux/wavefront.h	conflict!
>  0x02	all	linux/fd.h
>  0x03	all	linux/hdreg.h
> -0x04	all	linux/umsdos_fs.h
>  0x06	all	linux/lp.h
>  0x09	all	linux/md.h
>  0x12	all	linux/fs.h

NAK!

We should at least document which ioctl numbers have been burned, since
they SHOULD NOT be reused.

	-hpa
