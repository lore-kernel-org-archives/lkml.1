Return-Path: <linux-kernel-owner+w=401wt.eu-S1759101AbYADJAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbYADJAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 04:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbYADJAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 04:00:43 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:57832 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894AbYADJAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 04:00:42 -0500
Date: Fri, 4 Jan 2008 10:00:43 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@redhat.com>
Cc: hpa@rpath.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [10/16] Document fdimage/isoimage completely in make help
Message-ID: <20080104090043.GA28461@uranus.ravnborg.org>
References: <20080103442.621670000@suse.de> <20080103154224.47EA914DDB@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103154224.47EA914DDB@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 04:42:24PM +0100, Andi Kleen wrote:
> 
> Add missing targets and missing options in x86 make help
> 
> Cc: hpa@rpath.com
> Cc: sam@ravnborg.org

Ingo - I assume you add this to x86.git.

PS. It looks like we have a tab embeded in the echo statements -
    we should kill the remaining uses if thats correct.

	Sam


> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/Makefile |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> Index: linux/arch/x86/Makefile
> ===================================================================
> --- linux.orig/arch/x86/Makefile
> +++ linux/arch/x86/Makefile
> @@ -247,9 +247,13 @@ define archhelp
>    echo  '		   (your) ~/bin/installkernel or'
>    echo  '		   (distribution) /sbin/installkernel or'
>    echo  '		   install to $$(INSTALL_PATH) and run lilo'
> -  echo  '  bzdisk       - Create a boot floppy in /dev/fd0'
> -  echo  '  fdimage      - Create a boot floppy image'
> -  echo  '  isoimage     - Create a boot CD-ROM image'
> +  echo  '  fdimage      - Create 1.4MB boot floppy image (arch/x86/boot/fdimage)'
> +  echo  '  fdimage144	- Create 1.4MB boot floppy image (arch/x86/boot/fdimage)'
> +  echo  '  fdimage288	- Create 2.8MB boot floppy image (arch/x86/boot/fdimage)'
> +  echo  '  isoimage     - Create a boot CD-ROM image (arch/x86/boot/image.iso)'
> +  echo  '                  bzdisk/fdimage*/isoimage also accept:'
> +  echo  '                  FDARGS="..."  arguments for the booted kernel'
> +  echo  '                  FDINITRD=file initrd for the booted kernel'
>  endef
>  
>  CLEAN_FILES += arch/x86/boot/fdimage \
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
