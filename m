Return-Path: <linux-kernel-owner+w=401wt.eu-S932165AbZJLN70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbZJLN70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbZJLN70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:59:26 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:62805 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756576AbZJLN7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:59:25 -0400
From: Frans Pop <elendil@planet.nl>
To: "Toralf =?iso-8859-1?q?F=F6rster?=" <toralf.foerster@gmx.de>
Subject: Re: build issue #25 for v2.6.32-rc4-1-gd93a8f8 :"dma_controller_destroy" [drivers/usb/musb/musb_hdrc.ko] undefined!
Date: Mon, 12 Oct 2009 15:58:46 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Ajay Kumar Gupta <ajay.gupta@ti.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <200910121259.19208.toralf.foerster@gmx.de> <200910121409.40160.elendil@planet.nl>
In-Reply-To: <200910121409.40160.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910121558.48569.elendil@planet.nl>
X-OriginalArrivalTime: 12 Oct 2009 13:58:48.0784 (UTC) FILETIME=[1F433D00:01CA4B44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Frans Pop wrote:
> the build (.config attached) failed, make ends with :
> ...
> Kernel: arch/x86/boot/bzImage is ready  (#6)
>   Building modules, stage 2.
>   MODPOST 665 modules
> ERROR: "dma_controller_destroy" [drivers/usb/musb/musb_hdrc.ko] undefined!
> ERROR: "dma_controller_create" [drivers/usb/musb/musb_hdrc.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
>
> The build was made with :
> $>make randconfig; make clean; make

I just see this is also already being addressed/discussed. See:
http://lkml.org/lkml/2009/10/12/52

Cheers,
FJP
