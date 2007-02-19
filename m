Return-Path: <linux-kernel-owner+w=401wt.eu-S932303AbXBSOtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbXBSOtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932304AbXBSOtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:49:32 -0500
Received: from 195-13-16-24.net.novis.pt ([195.23.16.24]:43502 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbXBSOtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:49:31 -0500
X-Greylist: delayed 1443 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Feb 2007 09:49:31 EST
Message-ID: <45D9B356.9050009@grupopie.com>
Date: Mon, 19 Feb 2007 14:25:26 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.19.3 build faild with "Inconsistent kallsyms data"
References: <200702190917.16533.toralf.foerster@gmx.de>
In-Reply-To: <200702190917.16533.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf Förster wrote:
> Hello,
> 
> the build with the attached .config failed, make ends with:
> ...
> scripts/kconfig/conf -s arch/i386/Kconfig
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CHK     include/linux/compile.h
>   AS      .tmp_kallsyms2.o
>   LD      vmlinux
>   SYSMAP  System.map
>   SYSMAP  .tmp_System.map
> Inconsistent kallsyms data
> Try setting CONFIG_KALLSYMS_EXTRA_PASS
> make: *** [vmlinux] Error 1
> 
> Here's the config:

Hummm, I just tried that .config with a vanilla 2.6.19.3 and it built 
just fine.

So either you have some patches that make a difference, or it's a 
binutils version problem.

Can you send the output of scripts/ver_linux to see what binutils 
version you are using?

Also you can try a "make debug_kallsyms" build that creates a .tmp_map1 
and a .tmp_map2 files that might help diagnose the problem.

-- 
Paulo Marques - www.grupopie.com

"The face of a child can say it all, especially the
mouth part of the face."
