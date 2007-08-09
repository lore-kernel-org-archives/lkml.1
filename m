Return-Path: <linux-kernel-owner+w=401wt.eu-S935081AbXHIIkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935081AbXHIIkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 04:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758869AbXHIIkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 04:40:08 -0400
Received: from agave.telenet-ops.be ([195.130.137.77]:57338 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbXHIIkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 04:40:05 -0400
Date: Thu, 9 Aug 2007 10:40:00 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-fbdev-devel@lists.sourceforge.net
cc: Andi Kleen <ak@suse.de>, akpm@linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       "Antonino A. Daplas" <adaplas@pol.net>, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 1/2] x86_64 EFI boot support: EFI
 frame buffer driver
In-Reply-To: <1186647633.15539.15.camel@caritas-dev.intel.com>
Message-ID: <Pine.LNX.4.64.0708091038060.12872@anakin>
References: <1186647633.15539.15.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Huang, Ying wrote:
> Changelog between this version and previous version (v3 of x86_64 EFI
> support patch).
> 
> 1. The include files of efifb.c is cleaned up.
> 2. Make CONFIG_FB_EFI do not depend on CONFIG_EFI.

BTW, the recommended place to put changelogs (so the tools will strip
it automatically when importing your patch) is after the first `---' and
before the diffstat output

> ---

Bogus `---' :-)

> This patch adds Graphics Output Protocol support to the kernel.
> UEFI2.0 spec deprecates Universal Graphics Adapter (UGA) protocol and
> only Graphics Output Protocol (GOP) is produced. Therefore, the boot
> loader needs to query the UEFI firmware with appropriate Output
> Protocol and pass the video information to the kernel. As a result of
> GOP protocol, an EFI framebuffer driver is needed for displaying
> console messages. The patch adds a EFI framebuffer driver. The EFI
> frame buffer driver in this patch is based on the Intel Mac
> framebuffer driver.
> 
> The ELILO bootloader takes care of passing the video information as
> appropriate for EFI firmware.
> 
> The framebuffer driver has been tested in i386 kernel and x86_64
> kernel on EFI platform.
> 
> Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 

Missing `---' ;-)

>  drivers/video/Kconfig       |   11 ++
>  drivers/video/Makefile      |    1 
>  drivers/video/efifb.c       |  232 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/screen_info.h |    1 
>  4 files changed, 245 insertions(+)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
