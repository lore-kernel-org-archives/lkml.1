Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbYDFR65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbYDFR65 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 13:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYDFR6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 13:58:47 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:43001 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbYDFR6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 13:58:46 -0400
Date: Sun, 06 Apr 2008 13:57:51 -0400
From: David Hollis <dhollis@davehollis.com>
Subject: Re: [asix] add Buffalo LUA-U2-GT 10/100/1000
In-reply-to: <20080406140516.GA18335@inferi.kami.home>
To: Mattia Dongili <malattia@linux.it>
Cc: netdev@vger.kernel.org, dbrownell@users.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <1207504671.9989.0.camel@dhollis-lnx>
MIME-version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <20080406140516.GA18335@inferi.kami.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-04-06 at 23:05 +0900, Mattia Dongili wrote:
> The USB net adapter Buffalo LUA-U2-GT (0411:006e) carries a
> AX88178 chip. Tested on the above HW.
> 


Thanks for the report.  

Acked-off-by: David Hollis <dhollis@davehollis.com>


> Signed-off-by: Mattia Dongili <malattia@linux.it>
> ---
> diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
> index 6f245cf..dc6f097 100644
> --- a/drivers/net/usb/asix.c
> +++ b/drivers/net/usb/asix.c
> @@ -1381,6 +1381,10 @@ static const struct usb_device_id	products [] = {
>  	USB_DEVICE (0x0411, 0x003d),
>  	.driver_info =  (unsigned long) &ax8817x_info,
>  }, {
> +	// Buffalo LUA-U2-GT 10/100/1000
> +	USB_DEVICE (0x0411, 0x006e),
> +	.driver_info =  (unsigned long) &ax88178_info,
> +}, {
>  	// Sitecom LN-029 "USB 2.0 10/100 Ethernet adapter"
>  	USB_DEVICE (0x6189, 0x182d),
>  	.driver_info =  (unsigned long) &ax8817x_info,

