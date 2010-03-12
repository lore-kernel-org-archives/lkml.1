Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab0CLIo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 03:44:27 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:37305 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab0CLIo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 03:44:26 -0500
Message-ID: <4B99FEE5.4060609@monstr.eu>
Date: Fri, 12 Mar 2010 09:44:21 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Arun Bhanu <arun@bhanu.net>
CC: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH] microblaze: Add a missing single quote to make 'make
 help' happy
References: <1268382700-18218-1-git-send-email-arun@bhanu.net>
In-Reply-To: <1268382700-18218-1-git-send-email-arun@bhanu.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun Bhanu wrote:
> 'make ARCH=microblaze help' fails with the following error due to a
> missing single quote.
> 
> /bin/sh: -c: line 0: unexpected EOF while looking for matching `''
> /bin/sh: -c: line 1: syntax error: unexpected end of file
> make: *** [help] Error 2
> 
> Signed-off-by: Arun Bhanu <arun@bhanu.net>

Added to next branch.

Thanks,
Michal


> ---
>  arch/microblaze/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
> index d2d6cfc..f49d8e6 100644
> --- a/arch/microblaze/Makefile
> +++ b/arch/microblaze/Makefile
> @@ -83,7 +83,7 @@ define archhelp
>    echo '* linux.bin    - Create raw binary'
>    echo '  linux.bin.gz - Create compressed raw binary'
>    echo '  simpleImage.<dt> - ELF image with $(arch)/boot/dts/<dt>.dts linked in'
> -  echo '                   - stripped elf with fdt blob
> +  echo '                   - stripped elf with fdt blob'
>    echo '  simpleImage.<dt>.unstrip - full ELF image with fdt blob'
>    echo '  *_defconfig      - Select default config from arch/microblaze/configs'
>    echo ''


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
