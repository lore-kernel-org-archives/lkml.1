Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab0BMCPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 21:15:39 -0500
Received: from sypressi.dnainternet.net ([83.102.40.135]:33865 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab0BMCPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 21:15:37 -0500
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Feb 2010 21:15:37 EST
X-Spam-Flag: NO
X-Spam-Score: 0.049
Message-ID: <4B7609BD.7010009@iki.fi>
Date: Sat, 13 Feb 2010 04:09:01 +0200
From: Anssi Hannula <anssi.hannula@iki.fi>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100122 Mandriva/3.0.1-2mdv2010.1 (2010.1) Thunderbird/3.0.1
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes"
 causes gobi_loader to hang
References: <20100117025535.GB7045@srcf.ucam.org> <201002032358.03552.oliver@neukum.org> <20100205195817.GA14285@srcf.ucam.org> <201002052259.33645.oliver@neukum.org>
In-Reply-To: <201002052259.33645.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.02.2010 23:59, Oliver Neukum wrote:
> Am Freitag, 5. Februar 2010 20:58:17 schrieb Matthew Garrett:
>> drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
>> drivers/usb/serial/usb-serial.c: serial_write - port 0, 2048 byte(s)
>> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 2048 bytes
>> drivers/usb/serial/generic.c: usb_serial_generic_write - put 512 bytes into fifo
>> drivers/usb/serial/usb-serial.c: serial_write - port 0, 1536 byte(s)
>> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 1536 bytes
>> drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes into fifo
>> drivers/usb/serial/generic.c: usb_serial_generic_write - FIFO is full
> 
> OK, could you also get an usbmon trace? This would allow a determination
> whether the submitted URB doesn't finish for some reason, or whether
> no URB is submitted, possibly because a wakeup is missed.

I'm also affected by this regression. Here's an usbmon trace of
gobi_loader hanging:
http://stuff.onse.fi/gobi2000/gobi-regression.mon.log

-- 
Anssi Hannula
