Return-Path: <linux-kernel-owner+w=401wt.eu-S1761285AbYD2Uus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285AbYD2Uus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbYD2Uuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:50:40 -0400
Received: from mail.tpi.com ([198.107.51.143]:4803 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370AbYD2Uuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:50:40 -0400
X-Greylist: delayed 2544 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2008 16:50:40 EDT
Message-ID: <48178025.30807@canonical.com>
Date: Tue, 29 Apr 2008 14:08:05 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Kevin Lloyd <klloyd@sierrawireless.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH] USB: sierra: add support for Onda H600/Zte MF330
References: <20080429194710.174E2BB413C@sepang.rtg.net> <20719A9A7E5F8040AC0590F6F6C1DF460EEE0672E7@uscbd-exchmb01.sierrawireless.local>
In-Reply-To: <20719A9A7E5F8040AC0590F6F6C1DF460EEE0672E7@uscbd-exchmb01.sierrawireless.local>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Lloyd wrote:
> Hi Tim,
> 
> The sierra device driver is really trying to focus on Sierra vendor specific features and it might not be the best approach to add a Onda/Zte device here. Might I suggest the option driver? That is where the other Onda/Zte devices are stored.
> 
> -Kevin
> 
> -----Original Message-----
> From: Tim Gardner [mailto:timg@tpi.com]
> Sent: Tuesday, April 29, 2008 12:47 PM
> To: Kevin Lloyd
> Cc: linux-kernel@vger.kernel.org; tim.gardner@canonical.com
> Subject: [PATCH] USB: sierra: add support for Onda H600/Zte MF330
> 
> From: Bruno Redondi <bruno.redondi@altarisoluzione.com>
> Date: Fri, 1 Feb 2008 15:16:52 -0800
> Subject: [PATCH] USB: sierra: add support for Onda H600/Zte MF330 datacard to USB Driver for
>  Sierra Wireless
> 
> Added support for Onda H600/Zte MF330 GPRS/UMTS/HSDPA datacard
> 
> Signed-off-by: Bruno Redondi <bruno.redondi@altarisoluzione.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Amit Kucheria <amit.kucheria@ubuntu.com>
> Cc: stable@kernel.org
> ---
>  drivers/usb/serial/sierra.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
> index ed67881..da5a519 100644
> --- a/drivers/usb/serial/sierra.c
> +++ b/drivers/usb/serial/sierra.c
> @@ -179,6 +179,7 @@ static struct usb_device_id id_table [] = {
> 
>         { USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /* Sierra Wireless AirCard 580 */
>         { USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /* Airprime/Sierra PC 5220 */
> +       { USB_DEVICE(0x05C6, 0x6613), .driver_info = DEVICE_1_PORT }, /* Onda H600/ZTE MF330 */
> 
>         { USB_DEVICE(0x1199, 0x0FFF), .driver_info = DEVICE_INSTALLER},
>         { }
> --
> 1.5.4.3
> 
> 

You are correct. In fact, it is already in drivers/usb/serial/option.c
using QUALCOMM_VENDOR_ID.

rtg
-- 
Tim Gardner tim.gardner@ubuntu.com
