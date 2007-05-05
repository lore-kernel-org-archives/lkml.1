Return-Path: <linux-kernel-owner+w=401wt.eu-S933634AbXEERGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634AbXEERGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933632AbXEERGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:06:47 -0400
Received: from paperstreet.colino.net ([213.41.244.236]:50077 "EHLO
	paperstreet.colino.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933634AbXEERGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:06:46 -0400
X-Greylist: delayed 5000 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 May 2007 13:06:46 EDT
Date: Sat, 5 May 2007 12:49:54 +0200
From: Colin Leroy <colin@colino.net>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] led-class.c permission change
Message-ID: <20070505124954.0e2bcf53@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1cvs43 (GTK+ 2.10.11; i686-pc-linux-gnu)
X-Face: Fy:*XpRna1/tz}cJ@O'0^:qYs:8b[Rg`*8,+o^[fI?<%5LeB,Xz8ZJK[r7V0hBs8G)*&C+XA0qHoR=LoTohe@7X5K$A-@cN6n~~J/]+{[)E4h'lK$13WQf$.R+Pi;E09tk&{t|;~dakRD%CLHrk6m!?gA,5|Sb=fJ=>[9#n1Bu8?VngkVM4{'^'V_qgdA.8yn3)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAIVBMVEUAAwASFBYfISMyMTRGRUdaWFdxb2yJhoKrqaPOzMT19Ow5JzfkAAACW0lEQVQ4y6WTP1PbMBjGo6T/RkmmLWxIotCxtkRpmYqVMLAFY2i7AU0DbEDACVOvd6aED9DYnntg61NWCo0tt2N1vpyjn5/30ftIajT+Z4BVLLw3/0w7a+MsVXln8a/5x+E47fXT5FLW55ubP0ZFViTj6KImcXb7l5Pr4XD4JQo3bNDSVdIbLgLhd3ZssLwXHyUXwheACWnXivrx13bHRU3ECHMt6yjsDA8XIWygJsZeBZ5E/mrHBwAgpB9W1XodSw+Dh3cEvA8lODrQVR5i0Q8pTUB0Dq3I3LKTR/3cQyXC5KzM6b1Kugj9+YfI91LxWaUHej1gqsL0vAzkSiUHZqXGFToWuFUTSRHExEiarAsrcO1ThPDUpuVszAC4KgbcI7plQ5q4Cus2Dzh30e72w3ekbCnpSSERXpJGAdhs4Y35ImZiLVNn0y7RyqxzcKvUwDtRKne5JnhuFmJLKXXnZ/p3X0tAZQ4MONUy1UWgAXG1H/rj/HRLA1fbQuCUYN1Ueakp0UkCwMqgW1mhTvFxca67hxDxEoCtvNhHDtd5IQAc65Qs5PcSMbHjasD96iyA+TymlEujcIoza5tfFGlAKOceQm9VYG2/KFRAGeeUoOXUPtRsMupxJrkutTSuXYPonT4MbaNYOq6BlVHAPWEA34O1i5YGQmoPXWsP1a7aeEI5oxRj9LEOtu449SgmBB6FtVpPB9rBDChuagDs8Okg4FVG7Ft7eRKLtmnEWc66Fvg0Wc/boeQu7u6Ovln2PwcL6ZdO2yOrz3ujX6BySA6fpXEovbntcHNwb9x/A34/oQVbOAIKAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch changes the led brightness file's permissions to 0666, so that a 
user's MUA can light up the mail LED without needing root permissions.

Thanks! 

Signed-Off-By: Colin Leroy <colin@colino.net>
--- a/drivers/leds/led-class.c	2007-05-05 12:45:20.000000000 +0200
+++ b/drivers/leds/led-class.c	2007-05-05 12:41:28.000000000 +0200
@@ -56,7 +56,7 @@ static ssize_t led_brightness_store(stru
 	return ret;
 }
 
-static CLASS_DEVICE_ATTR(brightness, 0644, led_brightness_show,
+static CLASS_DEVICE_ATTR(brightness, 0666, led_brightness_show,
 			led_brightness_store);
 #ifdef CONFIG_LEDS_TRIGGERS
 static CLASS_DEVICE_ATTR(trigger, 0644, led_trigger_show, led_trigger_store);

