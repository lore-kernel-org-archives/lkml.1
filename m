Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbYASNYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbYASNYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 08:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYASNY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 08:24:27 -0500
Received: from allen.werkleitz.de ([80.190.251.108]:42719 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbYASNY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 08:24:26 -0500
X-Greylist: delayed 2880 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Jan 2008 08:24:26 EST
Message-ID: <4791EEF5.3090708@linuxtv.org>
Date: Sat, 19 Jan 2008 13:37:09 +0100
From: Michael Hunold <hunold@linuxtv.org>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: goodmen zy <goodmenkernel@gmail.com>
CC: linux-kernel@vger.kernel.org
References: <46f38fe70801190427p7d50beaeo67571b935a896283@mail.gmail.com>
In-Reply-To: <46f38fe70801190427p7d50beaeo67571b935a896283@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 84.137.234.36
Subject: Re: About the saa7146 driver
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on 19.01.2008 13:27 goodmen zy said the following:
> I have a PCI video capture card, and the command `lspci` tell me the
> following info:
> 
>      00:09.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
> 
> In the kernel source, I compiled the module saa7146.ko and saa7146_vv.ko.
> Those modules were inserted into kernel successfully.
> But I can't find any new device file in /dev.
> 
> Can you tell me the reason?

The saa7146 is a generic chipset that is used on quite a few different
cards. You only compiled and inserted the generic driver core for the
saa7146.

> Does the saa1746 module plays as a common driver for all the device
> with that chip?

No.

You are missing the extension module for the specific card you have.

For example, if you have a so-called "Multimedia eXtension Board", you
need to insert the "mxb.ko" driver as well.

Please tell me what kind of card that is, ie. brand, manufacturer, card
id etc. so I can tell you if there is a driver that supports it or not.

> Thanks!

Best regards
Michael.
