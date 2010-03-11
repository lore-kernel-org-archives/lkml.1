Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab0CKNYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:24:13 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:54306 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757220Ab0CKNYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:24:07 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: ZTE MF636 USB modem is not supported
Date: Thu, 11 Mar 2010 14:23:57 +0100
User-Agent: KMail/1.9.10
Cc: Ole Reier Ulland <ole.reier@netcom.no>, linux-kernel@vger.kernel.org
References: <201003110008.58644.ole.reier@netcom.no> <alpine.LRH.2.00.1003111415230.12517@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.1003111415230.12517@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003111423.58440.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 March 2010, Jiri Kosina wrote:
> On Thu, 11 Mar 2010, Ole Reier Ulland wrote:
> > I have reported this a while ago to the Mandriva bugzilla, but I cannot
> > see if anyone is doing anything about it. So now I just want to send the
> > link to this e-mail address to get a reply and some understanding.
> >
> > https://qa.mandriva.com/show_bug.cgi?id=57165
> >
> > [root@Dell_Dim Mine_Filer_1_FAT]# uname -a
> > Linux Dell_Dim 2.6.31.12-desktop-1mnb #1 SMP Tue Jan 26 03:35:36 EST 2010
> > i686 Intel(R) Pentium(R) 4 CPU 2.80GHz GNU/Linux
> >
> > Is it fixed already maybe? Is there another kernel that I can use?
> >
> > Is there anything else I can do to help this along?
>
> It is likely that your modem will need to have been switched to "serial"
> mode over from the default "storage" mode before it could be used
> (usb_modemswitch is an userspace application to do that for many ZTE
> modems).

Not sure about MF636, but MF637 works with this udev rule:
SUBSYSTEM=="usb", SYSFS{idVendor}=="19d2", SYSFS{idProduct}=="2000", RUN+="/usr/sbin/usb_modeswitch --default-vendor 0x19d2 --default-product 0x2000 --message-content 55534243123456782000000080000c85010101180101010101000000000000"

> Could you please post
>
> 1) dmesg once your modem is plugged in
> 2) lsusb -v output for this modem

-- 
Ondrej Zary
