Return-Path: <linux-kernel-owner+w=401wt.eu-S933058AbXCRTAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbXCRTAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 15:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXCRTAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 15:00:52 -0400
Received: from www17.your-server.de ([213.133.104.17]:3482 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058AbXCRTAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 15:00:51 -0400
Message-ID: <45FD8CA3.10405@m3y3r.de>
Date: Sun, 18 Mar 2007 20:01:55 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Soeren Sonnenburg <kernel@nn7.de>, Sergey Vlasov <vsu@altlinux.ru>,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: appletouch quirk doesn't run at resume
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703162134.14265.rjw@sisk.pl> <1174078066.13341.279.camel@localhost.localdomain> <1174087552.13341.332.camel@localhost.localdomain> <45FBBDEA.9060708@m3y3r.de> <20070318004240.GO752@stusta.de> <Pine.LNX.4.64.0703181934530.4195@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0703181934530.4195@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina schrieb:
> On Sun, 18 Mar 2007, Adrian Bunk wrote:
>
>   
> Thomas, could you please provide more information? Did it ever work for 
> you after suspend/resume cycle and it just broke at some point in the 
> past, or you are not sure whether it ever worked?
>   
I'm not sure whether this ever worked.
> Also, what exactly does it mean that it doesn't work? Are both the 
> interfaces after resume bound to usbhid driver (you can check this in 
> /sys)? When the quirk works correctly, only the keyboard interface should 
> be bound to usbhid driver. Please check the binding both before and after 
> suspend/resume cycle, and let me know.
>   
Appletouch is bound to the device:

T:  Bus=01 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  7 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=05ac ProdID=0218 Rev= 0.60
S:  Manufacturer=Apple Computer
S:  Product=Apple Internal Keyboard / Trackpad
C:* #Ifs= 3 Cfg#= 1 Atr=a0 MxPwr= 40mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=01 Driver=usbhid
E:  Ad=83(I) Atr=03(Int.) MxPS=   8 Ivl=8ms
I:* If#= 1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=appletouch
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=8ms
I:* If#= 2 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
E:  Ad=84(I) Atr=03(Int.) MxPS=   1 Ivl=8ms


But the X server touchpad driver doesn't work anymore, that means i
can't emulte a right click by tapping with 3 fingers on the mouse pad.
after restarting x the mouse driver works again. So i think this is
maybe a problem in X?


