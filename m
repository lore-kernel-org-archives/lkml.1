Return-Path: <linux-kernel-owner+w=401wt.eu-S1762420AbYENTM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762420AbYENTM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 15:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759130AbYENTMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 15:12:45 -0400
Received: from smtp6-g19.free.fr ([212.27.42.36]:51506 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761894AbYENTMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 15:12:44 -0400
To: Roel Kluin <roel.kluin@gmail.com>
Cc: dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ?] usb/gadget/pxa27x_udc: test ep0state == IN_DATA_STAGE rather than non-bool USB_DIR_IN
References: <482ABF15.8090006@gmail.com>
From: Robert Jarzmik <rjarzmik@free.fr>
Date: 14 May 2008 21:12:38 +0200
In-Reply-To: <482ABF15.8090006@gmail.com>
Message-ID: <87fxsksnrt.fsf@free.fr>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin <roel.kluin@gmail.com> writes:

> drivers/usb/gadget/pxa27x_udc.c uses USB_DIR_IN as if boolean in functions
> inc_ep_stats_{reqs,bytes}, lines 763, 795, 933, 985, 1037 and 1074, but
> USB_DIR_IN is defined 0x80.
Yes, USB_DIR_IN could be considered as a boolean (0x80 => true, 0x0 =>
false). I'm pretty sure it's correct.

> handle_ep0_ctrl_req() tests USB_DIR_IN bitwise and pxa_udc's ep0_state is set
> IN_DATA_STAGE or OUT_DATA_STAGE. so ep->dev->ep0state == IN_DATA_STAGE should be
> tested rather than USB_DIR_IN
No, I don't agree. Have you checked the USB 2.0 spec, especially on control
endpoint handling and control requests ?

Sorry Roel, I can't ack this patch.

--
Robert

