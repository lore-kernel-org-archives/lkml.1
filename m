Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZJLMKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZJLMKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZJLMKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:10:19 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:57944 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754558AbZJLMKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:10:18 -0400
From: Frans Pop <elendil@planet.nl>
To: "Toralf =?iso-8859-1?q?F=F6rster?=" <toralf.foerster@gmx.de>
Subject: Re: build issue #25 for v2.6.32-rc4-1-gd93a8f8 :"dma_controller_destroy" [drivers/usb/musb/musb_hdrc.ko] undefined!
Date: Mon, 12 Oct 2009 14:09:38 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Ajay Kumar Gupta <ajay.gupta@ti.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <200910121259.19208.toralf.foerster@gmx.de>
In-reply-To: <200910121259.19208.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910121409.40160.elendil@planet.nl>
X-OriginalArrivalTime: 12 Oct 2009 12:09:41.0012 (UTC) FILETIME=[E07C8540:01CA4B34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding relevant CCs.

Config is included in original message at:
http://lkml.org/lkml/2009/10/12/167

==========
Hello,

the build (.config attached) failed, make ends with :
...
Kernel: arch/x86/boot/bzImage is ready  (#6)
  Building modules, stage 2.
  MODPOST 665 modules
ERROR: "dma_controller_destroy" [drivers/usb/musb/musb_hdrc.ko] undefined!
ERROR: "dma_controller_create" [drivers/usb/musb/musb_hdrc.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

The build was made with :
$>make randconfig; make clean; make
