Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbZCZHrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbZCZHrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 03:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbZCZHrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:47:39 -0400
Received: from smtp.witbe.net ([81.88.96.48]:45833 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbZCZHri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:47:38 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2009 03:47:38 EDT
Date: Thu, 26 Mar 2009 08:42:20 +0100
From: Paul Rolland <rol@as2917.net>
To: linux-kernel@vger.kernel.org
Cc: rol@as2917.net
Subject: Linux 2.6.x - Serial port signalling not maintained when closing
 device
Message-ID: <20090326084220.4def5652@tux.DEF.witbe.net>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.8; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm using small devices that are connected on the serial port, and powered
using RTS and DTR.
When using kernel 2.4.x (at least 2.4.31), I could easily control the
powering of the device using :
 stty -F /dev/ttyS0 ospeed 9600 (this would put RTS and DTR to 1 / power)
and
 stty -F /dev/ttyS0 ospeed 0 (this would turn it off).

I've recently updated one of the machine to a new 2.6.29 kernel, and this
is not working anymore.
As far as I can see, I need to have an application that keeps /dev/ttyS0
open for this to work. As soon as no application is using the port,
everything goes down again.

This is a significant change between 2.4.x and 2.6.x. Is there a way to
change 2.6.x behavior to go back to the 2.4.x ? When was this change
introduce ?

This serial port controler is a 16550A, the machine is an x86 platform, so
nothing unusual.

Best regards,
Paul
