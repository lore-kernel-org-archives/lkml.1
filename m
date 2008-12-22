Return-Path: <linux-kernel-owner+w=401wt.eu-S1757726AbYLVWKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbYLVWKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbYLVVwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:52:47 -0500
Received: from styx.suse.cz ([82.119.242.94]:41073 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756463AbYLVVwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:52:45 -0500
Date: Mon, 22 Dec 2008 22:52:43 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Parag Warudkar <parag.lkml@gmail.com>
cc: Anssi Hannula <anssi.hannula@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] USBHID: Make Boot Protocol drivers depend on EMBEDDED
In-Reply-To: <alpine.DEB.2.00.0812211441300.7101@parag-desktop>
Message-ID: <alpine.LNX.1.10.0812222252260.26265@jikos.suse.cz>
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com>  <20081220221253.e09b1b1f.akpm@linux-foundation.org>  <f7848160812202226w1f930c86vfd17a2b0163bfc56@mail.gmail.com>  <494E20F7.7050106@gmail.com> <f7848160812210717w5e5cc7a2uc5571710f755ec99@mail.gmail.com>
 <alpine.LRH.1.10.0812211824350.11630@twin.jikos.cz> <alpine.DEB.2.00.0812211441300.7101@parag-desktop>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Dec 2008, Parag Warudkar wrote:

> The usbmouse and usbkbd modules are not supposed to be used with regular 
> USB mice and keyboards. Make them depend on EMBEDDED to prevent them from 
> being built and loaded on non-EMBEDDED configs.
> Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>
> 
> diff --git a/drivers/hid/usbhid/Kconfig b/drivers/hid/usbhid/Kconfig
> index 5d9aa95..4edb3be 100644
> --- a/drivers/hid/usbhid/Kconfig
> +++ b/drivers/hid/usbhid/Kconfig
> @@ -45,7 +45,7 @@ config USB_HIDDEV
>  	  If unsure, say Y.
>  
>  menu "USB HID Boot Protocol drivers"
> -	depends on USB!=n && USB_HID!=y
> +	depends on USB!=n && USB_HID!=y && EMBEDDED
>  
>  config USB_KBD
>  	tristate "USB HIDBP Keyboard (simple Boot) support"

Applied, thanks Parag.

-- 
Jiri Kosina
SUSE Labs
