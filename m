Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbYLVFVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbYLVFVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 00:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbYLVFVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 00:21:11 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:47042 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbYLVFVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 00:21:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IOioDzUeXp7SUXhNA+86u3gINjrAqvhdZaM6o1porRS93Nn7L6ZcXQjl4q2eXVj2N6
         oMhy0y0EU3x+kEvGi0mdrFzbr1LYNgFC1mGvPrpC/DVgpCAkMrAIij0hNgSxsRF2nkKP
         B8clOADPgg6snOpdijrNoguvGdKEvpzIpYnmw=
Date: Mon, 22 Dec 2008 13:18:58 +0800
From: arrow.ebd@gmail.com
To: Matan Ziv-Av <matan@svgalib.org>
Cc: arrow.ebd@gmail.com, linux_kernel <linux-kernel@vger.kernel.org>,
       frank@kingswood-consulting.co.uk
Subject: Re: usb-serial: how to let ch341 work with baudrate 57600 ?
Message-ID: <20081222051858.GA4615@think>
References: <20081221032746.GA4502@think> <alpine.LFD.2.00.0812211611210.11887@matan.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812211611210.11887@matan.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 04:19:01PM +0200, Matan Ziv-Av wrote:
> On Sun, 21 Dec 2008, arrow.ebd@gmail.com wrote:
>> dear frank,
>>
>> 	I have a USB-to-RS232 connector with chip ch341, but it
>> can not work under baud rate 57600.
>>
>> 	I checked baud rate is set in function "ch341_set_baudrate".
>>
>> 	How can I setup it with baudrate 57600 ?
>>
>> 	I would like hear from you, Or give me some suggestion
>> to hack it.
>
> See here: http://lkml.org/lkml/2008/9/21/17 for a patch that allows  
> arbitrary baud rate.
> -- 
> Matan Ziv-Av.                         matan@svgalib.org

Thanks for your information, I have tried it, but can not work, dmesg
as below:(what should me to do)

[ 2416.718758] drivers/usb/serial/ch341.c: ch341_open()
[ 2416.718766] drivers/usb/serial/ch341.c: ch341_configure()
[ 2416.718774] drivers/usb/serial/ch341.c: ch341_control_in(c0,5f,0000,0000,f60f9838,8)
[ 2416.720055] drivers/usb/serial/ch341.c: ch341_control_out(40,a1,0000,0000)
[ 2416.721035] drivers/usb/serial/ch341.c: ch341_set_baudrate(2400)
[ 2416.721042] drivers/usb/serial/ch341.c: ch341_control_out(40,9a,1312,d901)
[ 2416.722028] drivers/usb/serial/ch341.c: ch341_control_out(40,9a,0f2c,0006)
[ 2416.723068] drivers/usb/serial/ch341.c: ch341_control_in(c0,95,2518,0000,f60f9838,8)
[ 2416.724035] drivers/usb/serial/ch341.c: ch341_control_out(40,9a,2518,0050)
[ 2416.725062] drivers/usb/serial/ch341.c: ch341_get_status()
[ 2416.725069] drivers/usb/serial/ch341.c: ch341_control_in(c0,95,0706,0000,f60f9840,8)
[ 2416.726030] drivers/usb/serial/ch341.c: ch341_control_out(40,a1,501f,d90a)
[ 2416.727114] drivers/usb/serial/ch341.c: ch341_set_baudrate(2400)
[ 2416.727121] drivers/usb/serial/ch341.c: ch341_control_out(40,9a,1312,d901)
[ 2416.727988] drivers/usb/serial/ch341.c: ch341_control_out(40,9a,0f2c,0006)
[ 2416.729062] drivers/usb/serial/ch341.c: ch341_set_handshake(0x60)
[ 2416.729068] drivers/usb/serial/ch341.c: ch341_control_out(40,a4,ff9f,0000)
[ 2416.730287] drivers/usb/serial/ch341.c: ch341_get_status()
[ 2416.730296] drivers/usb/serial/ch341.c: ch341_control_in(c0,95,0706,0000,f60f9840,8)
[ 2416.731064] drivers/usb/serial/ch341.c: ch341_set_handshake(0x60)
[ 2416.731070] drivers/usb/serial/ch341.c: ch341_control_out(40,a4,ff9f,0000)
[ 2416.732064] drivers/usb/serial/ch341.c: ch341_set_baudrate(2400)
[ 2416.732071] drivers/usb/serial/ch341.c: ch341_control_out(40,9a,1312,d901)
[ 2416.733063] drivers/usb/serial/ch341.c: ch341_control_out(40,9a,0f2c,0006)
[ 2416.734064] drivers/usb/serial/ch341.c: ch341_open - submitting interrupt urb
[ 2416.734071] ch341-uart ttyUSB0: ch341_open - failed submitting interrupt urb, error -2
[ 2416.734079] drivers/usb/serial/ch341.c: ch341_close - port 0
[ 2416.734084] drivers/usb/serial/ch341.c: ch341_close - shutting down urbs
[ 2416.734091] drivers/usb/serial/ch341.c: ch341_set_handshake(0x00)
[ 2416.734097] drivers/usb/serial/ch341.c: ch341_control_out(40,a4,ffff,0000)

I have checked the "erro -2" was occured at "usb_submit_urb" "return -ENOENT".
