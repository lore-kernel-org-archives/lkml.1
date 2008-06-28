Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbYF1PxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbYF1PxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 11:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYF1Pw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 11:52:57 -0400
Received: from viefep28-int.chello.at ([62.179.121.48]:5362 "EHLO
	viefep28-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYF1Pw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 11:52:56 -0400
X-Greylist: delayed 2311 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jun 2008 11:52:55 EDT
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
To: Alastair Bridgewater <nyef@lisphacker.com>
Subject: Re: [PATCH] input: Add support for eGalax TouchKit USB touchscreen used on HP tx1305us
Date: Sat, 28 Jun 2008 17:57:47 +0200
User-Agent: KMail/1.9.6
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
References: <200806281719.16837.daniel.ritz-ml@swissonline.ch>
In-Reply-To: <200806281719.16837.daniel.ritz-ml@swissonline.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806281757.48201.daniel.ritz-ml@swissonline.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 June 2008 17:19:16 Daniel Ritz wrote:
> hi
> 
> > The eGalax touchscreen used in the HP tx1305us tablet PC (and presumably 
> > the rest of the tx1000 series) uses a different format for events from 
> > the device than the existing driver supports.
> > 
> is there more information available? datasheets? drivers?
> 
> > Add a new device description and interrupt packet handler for the 
> > touchscreen used in the tx1305us, claiming the USB device ID for the 
> > device that this patch was tested with from the older eGalax device code.
> >
> NAK. you cannot change device IDs currently used to some new code.
> this will break most eGalax setups as the device ID 0x0eef,0x0001 is used
> in most of them, including the one i have..
> 
> you'll need to find a way to distinguish the screens. as a starting point
> i attached an lsusb -vvv output from my screen...
> 

reading the latest driver guide and programming guide from eGalax (now EETI btw.
www.eeti.com.tw ) it turns out that the newer devices should support the HID
format and report with that by default. those newer screens are handled by the
'usbhid' driver. have you tried loading that one before usbtouchscreen?

can you give an lsusb -vvv output?

in case the usbhid driver does not work, it's possible to put the touchscreen
into the non-HID operating mode and have to current code work again..it's easy
to code...but please try usbhid first...

rgds
-daniel

