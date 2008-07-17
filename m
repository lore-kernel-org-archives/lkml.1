Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbYGQJnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbYGQJnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbYGQJnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:43:42 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:33471 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbYGQJnl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:43:41 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 00/11] fsl_usb2_udc: A number of bug fixes and cleanups.
Date: Thu, 17 Jul 2008 17:43:29 +0800
Message-ID: <989B956029373F45A0B8AF0297081890027C4EC2@zch01exm26.fsl.freescale.net>
In-Reply-To: <1216135490-21656-1-git-send-email-will.newton@imgtec.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 00/11] fsl_usb2_udc: A number of bug fixes and cleanups.
Thread-Index: AcjmjvLBvmE+1lUjT8alBu37+/18BgBYG7lA
References: <1216135490-21656-1-git-send-email-will.newton@imgtec.com>
From: "Li Yang" <LeoLi@freescale.com>
To: "Will Newton" <will.newton@imgtec.com>, <linux-kernel@vger.kernel.org>
Cc: <linux-usb@vger.kernel.org>, "Jiang Bo" <tanya.jiang@freescale.com>,
       <gregkh@suse.de>, "Will Newton" <will.newton@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Will Newton [mailto:will.newton@imgtec.com] 
> Sent: Tuesday, July 15, 2008 11:25 PM
> To: linux-kernel@vger.kernel.org
> Cc: linux-usb@vger.kernel.org; Li Yang; Jiang Bo; 
> gregkh@suse.de; Will Newton
> Subject: [PATCH 00/11] fsl_usb2_udc: A number of bug fixes 
> and cleanups.
> 
> From: Will Newton <will.newton@gmail.com>
> 
> Hi,
> 
> These patches fix a couple of small bugs and cleanup parts of 
> the fsl_usb2_udc USB gadget driver. I've split them up quite 
> finely for ease of reviewing and to separate functional 
> changes. Any comments would be appreciated.
> 
> I would also appreciate it if someone with real Freescale 
> hardware could test these changes, I'm testing this driver 
> with a different SoC containing the same TDI/ARC/ChipIdea IP block.

Thanks for the patches.  Looks like they are ok, but I still need to
test them later.

What's the SoC you have tested with the driver?  Maybe you could also
update the Kconfig for that.

- Leo
> 
> Thanks,
> 
> Will Newton (11):
>   fsl_usb2_udc: Make dr_ep_setup function static.
>   fsl_usb2_udc: Remove check for udc == NULL in dr_controller_setup.
>   fsl_usb2_udc: Fix some sparse warnings and remove redundant code.
>   fsl_usb2_udc: Clean up whitespace in errors and warnings.
>   fsl_usb2_udc: Clean up whitespace in /proc debugging output.
>   fsl_usb2_udc: Initialize spinlock earlier.
>   fsl_usb2_udc: Rename the arguments of the fsl_writel macro.
>   fsl_usb2_udc: Uninline udc_reset_ep_queue.
>   fsl_usb2_udc: Make fsl_queue_td return type void.
>   fsl_usb2_udc: Add a wmb before priming endpoint.
>   fsl_usb2_udc: Fix oops on probe failure.
> 
>  drivers/usb/gadget/fsl_usb2_udc.c |  176 
> ++++++++++++++++--------------------
>  drivers/usb/gadget/fsl_usb2_udc.h |   21 +----
>  2 files changed, 80 insertions(+), 117 deletions(-)
> 
> -
> This message is subject to Imagination Technologies' e-mail 
> terms: http://www.imgtec.com/e-mail.htm
> -
> 
> 
