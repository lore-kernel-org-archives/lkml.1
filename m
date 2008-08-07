Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbYHGN3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbYHGN3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYHGN3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:29:12 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:50156 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYHGN3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:29:12 -0400
Date: Thu, 07 Aug 2008 06:24:11 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] radeon_cp: use request_firmware
In-reply-to: <1218095497.4016.3.camel@jaswinder.satnam>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: martin@valinux.com, gareth@valinux.com, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Message-id: <200808070624.12214.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <1218095497.4016.3.camel@jaswinder.satnam>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 August 2008, Jaswinder Singh wrote:
>Moved datah before datal because datah is required before datal.
>
>Firmware blob looks like this...
>	__be32 datah
>	__be32 datal
>
>Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>

When applied to 2.6.27-rc2, firmware/Makefile was rejected, so I manually added 
the blob list to that Makefile in what looked to be the correct place.  And added a
"make firmware_install" to my kernel builder script.

Unforch:
  MK_FW   firmware/R100_cp.bin.ihex.gen.S
make[1]: *** No rule to make target `firmware/R100_cp.bin.ihex', needed by `firmware/R100_cp.bin.ihex.gen.o'.  Stop.
make[1]: *** Waiting for unfinished jobs....
make: *** [firmware] Error 2

I suspect I need to go back and hand edit the .config to add the "radeon/"
in front of each of those, so its looking for
 "firmware/radeon/R100_cp.bin.ihex" in each of those cases.  Correct?  Or can
I use "radeon/*" ?

[...]

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Fiber optics caused gas main leak
