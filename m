Return-Path: <linux-kernel-owner+w=401wt.eu-S1030788AbXEPVEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030788AbXEPVEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757466AbXEPVE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:04:27 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:51404 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbXEPVE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:04:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UYLy+UQ0oVl6bh14M+6Doyz1PVw436NB89f/ghdKk61xwiwTG1sd+sax3a1wF0FCVnO0Aqw3tBXiZlXs9AVlOX58bt8kHSVQX7Q0fVPDHP1pIZGXSe/ckvU1f/l0MjjRhPRMQK6o+yaUDS1Fwwe/VpXUc8gBEo7qXeczX+IbF6M=
Message-ID: <464B71EF.8060602@gmail.com>
Date: Wed, 16 May 2007 23:04:47 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Ben Collins <ben.collins@ubuntu.com>
CC: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Ganesh Varadarajan <ganesh@veritas.com>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH] Remove duplicate ID in ipaq driver
References: <1179348840.6510.16.camel@cunning>
In-Reply-To: <1179348840.6510.16.camel@cunning>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Collins napsal(a):
> Cc: Ganesh Varadarajan <ganesh@veritas.com>
> Cc: linux-usb-devel@lists.sourceforge.net
> Signed-off-by: Ben Collins <bcollins@ubuntu.com>
> 
> diff --git a/drivers/usb/serial/ipaq.c b/drivers/usb/serial/ipaq.c
> index 4df0ec7..7c85be4 100644
> --- a/drivers/usb/serial/ipaq.c
> +++ b/drivers/usb/serial/ipaq.c
> @@ -92,7 +92,6 @@ static void ipaq_destroy_lists(struct usb_serial_port *port);
>  
>  static struct usb_device_id ipaq_id_table [] = {
>  	/* The first entry is a placeholder for the insmod-specified device */

I wonder if the people ever read the comments? ^^^^^^^^^
It's used for parameter from command line when modprobing. See ipaq_init.

> -	{ USB_DEVICE(0x049F, 0x0003) },
>  	{ USB_DEVICE(0x0104, 0x00BE) }, /* Socket USB Sync */
>  	{ USB_DEVICE(0x03F0, 0x1016) }, /* HP USB Sync */
>  	{ USB_DEVICE(0x03F0, 0x1116) }, /* HP USB Sync 1611 */
> 

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
