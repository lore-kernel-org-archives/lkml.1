Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbXFLVdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbXFLVdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 17:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbXFLVdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 17:33:46 -0400
Received: from smtp1.versatel.nl ([62.58.50.88]:56356 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbXFLVdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 17:33:45 -0400
Message-ID: <466F1462.5090008@hhs.nl>
Date: Tue, 12 Jun 2007 23:47:14 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Stanislav Brabec <sbrabec@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>
Subject: Proposal: change keycode for scancode e0 32 from 150 to 172
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

As some of you might know from my earlier post/thread about atkbd and softraw, 
I'm currently working on getting keyboards with internet/easy access keys to 
work painlessly / plug and play.

In order to be able to better test / develop this I've bought 2 cheap such 
keyboards today, one ps2 and one both usb and ps2 capable.

When comparing usb vs ps2 / testing the keycodes generated for the easy access
keys on my trust (microsoft compatible) keyboard. I noticed the homepage key 
sends keycode 150 with ps2 and 172 with USB, or for those who don't know the 
keycodes by head with ps2 it sends KEY_WWW and with usb it sends KEY_HOMEPAGE

I personally believe that the usb behaviour is correct and that the ps/2 code 
should be modified to match for consistency. The ps/2 scancode to keycode 
mapping is set up to handle easy access / internet keys for microsoft 
compatible keyboards. So what is the right code to send here, tricky, see:
http://www.s2.com.br/s2arquivos/361/Imagens/555Image.jpg
http://www.keyboardco.com/keyboard_images/microsoft_ergonomic_keyboard_4000_black_usb_large.jpg

The logo on the key is a homepage logo, the text below is www/homepage. So what 
to send? I believe that for consistency with the usb codes send it should be 
KEY_HOMEPAGE, but thats based on a sample of 1 usb keyboard. Input on what 
other usb keyboards send for the key with the homepage iocn is very much welcome.

Regards,

Hans
