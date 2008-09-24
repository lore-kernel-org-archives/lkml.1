Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbYIXSzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbYIXSzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYIXSy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:54:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:16375 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbYIXSy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:54:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=vgRmjee8tCD0TgkTRYuBTRrEEl5SrhOgofY/i257CRKICMk9E/rOqDVUwrsJumVzkq
         jgfo2nOSfUjh15v7Qbg8QiXiF0KDNgqCE+pcpPoWhP/mTJILbPg8dcAGIOHcPITBYOzj
         t/ceXPOnbzd0KkUYBu4D3c6jqRftAtSShCISk=
Message-ID: <48DA8CFC.9020304@gmail.com>
Date: Wed, 24 Sep 2008 20:54:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: suspend (uhci_hcd) defunct in mmotm 2008-09-13-03-09
References: <48DA64FC.4020706@gmail.com> <Pine.LNX.4.44L0.0809241229070.5963-100000@iolanthe.rowland.org> <20080924181403.GA6336@kroah.com> <48DA84C9.3010707@gmail.com>
In-Reply-To: <48DA84C9.3010707@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2008 08:19 PM, Jiri Slaby wrote:
> I see, I need to boot to that kernel anyway, with dynamic_printk param this time.

It didn't work as I expected, nevermind, here comes updated dmesg:
http://decibel.fi.muni.cz/~xslaby/dmesg_fail.hcd

I seem to overlooked the pci identification before. There are my mouse and kbd
connected to that hub behind another hub.
Attaching lsusb -tv again:
/:  Bus 08.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 07.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 06.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
    |__ Port 1: Dev 2, If 0, Class=hub, Driver=hub/3p, 12M
        |__ Port 1: Dev 3, If 0, Class=HID, Driver=usbhid, 12M
        |__ Port 1: Dev 3, If 1, Class=HID, Driver=usbhid, 12M
        |__ Port 2: Dev 4, If 0, Class=HID, Driver=usbhid, 1.5M
/:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/6p, 480M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/6p, 480M
Full lsusb -vvv version at:
http://decibel.fi.muni.cz/~xslaby/lsusb.hcd
