Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbXLFLqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbXLFLqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 06:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbXLFLp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 06:45:58 -0500
Received: from otello.alma.unibo.it ([137.204.24.163]:58214 "EHLO
	otello.alma.unibo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbXLFLp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 06:45:57 -0500
X-Greylist: delayed 8001 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2007 06:45:56 EST
Message-ID: <4757B288.7060907@otello.alma.unibo.it>
Date: Thu, 06 Dec 2007 09:27:52 +0100
From: Diego Zuccato <diego@otello.alma.unibo.it>
User-Agent: Thunderbird 2.0.0.9 (X11/20071114)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jeff Garzik <jeff@garzik.org>, Mark Lord <lkml@rtr.ca>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, rubini@vision.unipv.it,
       linux-input@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: REGRESSION: 2.6.24:  false double-clicks from USB mouse
References: <4752DB8C.50608@rtr.ca> <4752E432.10504@rtr.ca> <4752E5AD.40905@rtr.ca> <4752F226.1090003@garzik.org> <Pine.LNX.4.64.0712021907490.13260@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0712021907490.13260@jikos.suse.cz>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina ha scritto:

>> My USB mouse recently started giving me phantom scrolls (movements of 
>> the mouse wheel, even I made sure the wheel was in a resting position) 
>> in recently kernels.  It happened too infrequently for me to care.
> Did this also start in 2.6.24, as in Mark's case?
It happens to me, too.
Wireless mouse, gives some "wheel up" signals when going into powersave
state. Kernel is 2.6.22-tmb-laptop-2mdv (Mandriva Cooker).

T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=1.5 MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=062a ProdID=0000 Rev= 0.00
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=10ms

Maybe a more-or-less undocumented sequence to tell the host it's going
to sleep?

BYtE,
 Diego.
