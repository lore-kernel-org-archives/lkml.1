Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab0BDLps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 06:45:48 -0500
Received: from smtp.witbe.net ([81.88.96.48]:33070 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757163Ab0BDLpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 06:45:47 -0500
Date: Thu, 4 Feb 2010 12:45:44 +0100
From: Paul Rolland <rol@as2917.net>
To: Oliver Neukum <oliver@neukum.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
       rol@as2917.net
Subject: Re: usbserial speed limitations ?
Message-ID: <20100204124544.7e29ea3f@tux.DEF.witbe.net>
In-Reply-To: <201002041226.21379.oliver@neukum.org>
References: <20100204095855.10993d1a@tux.DEF.witbe.net>
	<201002041226.21379.oliver@neukum.org>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

On Thu, 4 Feb 2010 12:26:21 +0100
Oliver Neukum <oliver@neukum.org> wrote:

> Am Donnerstag, 4. Februar 2010 09:58:55 schrieb Paul Rolland:
> > "Maximum connection speed is limited by the current generic usbserial
> > driver to approximately less than 500kbps."
> > 
> > Is there really such a speed limitation in the usbserial module/driver ?
> > This modem is HSPA+, which should allow a theorical maximum downspeed of
> > 20MBps, not 500kbps...
> 
> In the generic usbserial driver this speed limit indeed exists.
> But you are not supposed to use it with that kind of device.
> Most likely the correct driver would be either option or sierra.
> Please post lsusb -v for your device.

I don't have yet the device, but the informations I have so far are :
 - It is Vendor ID 0x1410, product ID 0x5023 when connected for the first
   time, and then it is a disk device.
 - Ejecting it makes it appear as Vendor ID 0x1410, product ID 0x7030

Novatel also refers to their procedure for the linux installation :
(http://www.nvtl.com/index.php?option=com_content&view=article&id=139&Itemid=305
which has a link to 
http://www.nvtl.com/index.php?option=com_content&view=article&id=176&Itemid=331)

This applies to Ovation MC930D and Ovation MC950D, which are supported by
option.c

So, I suspect the best would be to add the 0x7030 Product ID in the option
driver, and git it a shoot...

Regards,
Paul
