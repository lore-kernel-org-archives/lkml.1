Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab0BDJMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:12:41 -0500
Received: from smtp.witbe.net ([81.88.96.48]:47148 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756798Ab0BDJMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:12:37 -0500
X-Greylist: delayed 821 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Feb 2010 04:12:37 EST
Date: Thu, 4 Feb 2010 09:58:55 +0100
From: Paul Rolland <rol@as2917.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: usbserial speed limitations ?
Message-ID: <20100204095855.10993d1a@tux.DEF.witbe.net>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm about to start working with a new USB 3G+ modem (Novatel Wireless
M996D), details :

  Product ID:	0x5023
  Vendor ID:	0x1410  (Novatel Wireless, Inc.)
  Version:	 0.00
  Speed:	Up to 480 Mb/sec
  Manufacturer:	Novatel Wireless, Inc

>From the manufacturer web site, regarding the installation, I can read :

"Maximum connection speed is limited by the current generic usbserial
driver to approximately less than 500kbps."

Is there really such a speed limitation in the usbserial module/driver ?
This modem is HSPA+, which should allow a theorical maximum downspeed of
20MBps, not 500kbps...

The machine intended for such use in 2.6.28.x. Is there any chance to have
something better with a newer kernel ?

Any help / hint appreciated...

Regards,
Paul
