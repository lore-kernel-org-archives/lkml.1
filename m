Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbXJAKFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbXJAKFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 06:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbXJAKFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 06:05:10 -0400
Received: from mail.syneticon.net ([213.239.212.131]:43146 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbXJAKFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 06:05:09 -0400
Message-ID: <4700C649.90300@wpkg.org>
Date: Mon, 01 Oct 2007 12:04:57 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Miguel <mc354@tid.es>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: software unplug and plug USB
References: <46FCF0F5.9030004@wpkg.org> <1191224165.6014.12.camel@McM> <4700A44C.2010700@wpkg.org> <1191226692.6014.16.camel@McM>
In-Reply-To: <1191226692.6014.16.camel@McM>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel schrieb:
> I also have a mobile phone connected, a gps and a keyboard, i do the
> following:
> 
> 
> ecar@ecar:~$ lsmod | grep usb
> usbserial              29928  1 pl2303
> usbtouchscreen          8708  0 
> usbcore               130304  7
> libusual,pl2303,usbserial,usbtouchscreen,ehci_hcd,uhci_hcd
> ecar@ecar:~$ rmmod pl2303
> ERROR: Removing 'pl2303': Operation not permitted
> ecar@ecar:~$ sudo rmmod pl2303
> ecar@ecar:~$ sudo rmmod usbserial

  Only then It's not enough. You also have to remove ehci_hcd / uhci_hcd 
/ ohci_hcd.the device will be powered off (unless the method described 
in the link given by Jiri Slaby powers the device off, too).


> ecar@ecar:~$ modprobe usbserial
> FATAL: Error inserting usbserial
> (/lib/modules/2.6.17-11-386/kernel/drivers/usb/serial/usbserial.ko):
> Operation not permitted
> (reverse-i-search)`mod': cd backup_modules/

cd backup_modules/? Where do you keep your modules?


-- 
Tomasz Chmielewski
http://blog.wpkg.org
