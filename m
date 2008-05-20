Return-Path: <linux-kernel-owner+w=401wt.eu-S1764024AbYETSRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764024AbYETSRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbYETSRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:17:44 -0400
Received: from smtp.witbe.net ([81.88.96.48]:40649 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbYETSRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:17:43 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2008 14:17:43 EDT
Date: Tue, 20 May 2008 20:11:57 +0200
From: Paul Rolland <rol@as2917.net>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: rol@as2917.net
Subject: SATA hotplug device renaming and dmraid...
Message-ID: <20080520201157.21c31481@tux.DEF.witbe.net>
Organization: AS2917.net
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm using a machine that supports SATA hotplug and with and Intel ESB2
(Fake)Raid controller.
I've configured a raid1 (mirror) array using dmraid, that is made of 
/dev/sda and /dev/sdb, and seen by the OS as /dev/mapper/isw_xxxxxxx_RAID1

My problem is that when I unplug and replug a disk, it is assigned a 
new name (/dev/sdc first time as this is the first name available), and
so it is no more considered as being part of the RAID array.

Is this an expected behavior ? Is there a way (using dmraid/dmsetup) to
instruct kernel of the changes ? 

It seems that udev can get events from device-mapper, from
Documentations/device-mapper/dm-xxxx.txt, but I don't really see how to use
this to notify of a disk change in the array...

Regards,
Paul
