Return-Path: <linux-kernel-owner+w=401wt.eu-S1757832AbYHKVUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbYHKVUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYHKVUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:20:39 -0400
Received: from blu0-omc1-s25.blu0.hotmail.com ([65.55.116.36]:43766 "EHLO
	blu0-omc1-s25.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700AbYHKVUi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:20:38 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Aug 2008 17:20:38 EDT
Message-ID: <BLU144-W16078F8A713E4D9EAA1E98D1710@phx.gbl>
X-Originating-IP: [129.97.84.113]
From: d i <navilein@hotmail.com>
To: <linux-kernel@vger.kernel.org>
CC: <navilein@hotmail.com>
Subject: p54usb not working on DWL-G120 Spinnaker wireless card
Date: Mon, 11 Aug 2008 21:14:28 +0000
Importance: Normal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 11 Aug 2008 21:14:29.0020 (UTC) FILETIME=[3DAB75C0:01C8FBF7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
I can't get my wireless card DWL-G120 Spinnaker to work with the p54usb module which is in the kernel tree. 
The kernel help page for the p54usb module says that this module should work with the DWL-G120 Spinnaker wireless card.

I now have kernel 2.6.25-r7, but I kept trying to use the p54usb module with my card unsuccessfully since it appeared in the kernel tree (around February this year) -- it never worked. 
I use firmware version 2.5.6.0 from the prism54.org website. I tried with other versions of firmware as well, but most of them did not even load up (error -22 and error -110).

With firmware 2.5.6.0 the module loads up, but scanning for APs reveals no answer, ever. If I set an ESSID of a network I KNOW is around and not crypted it does not set the AP address and the "Link Quality" is always 0  and  it never connects.
The card can not be set in monitor mode.
I can set the card in ad-hoc mode ONLY if the interface is down. If afterwards I try to bring the interface up (with ifconfig), I get an error, and the interface does not come up.
After a while (never fixed) the kernel Oops. 

Both the failure to work and the final unpredictable kernel Oops are always reproducible, although the time it takes the kernel to Oops varies every time.

I've tried this with 3 desktop computers and 1 laptop and all have the same behavior. The wireless card works well in windows or in linux under ndiswrapper.

Did anyone manage to have this wireless card (DWL-G120) working with this module (p54usb) ?

Thanks,
Daniel.

If you have an answer or comment, please CC the message to my email: navilein@hotmail.com
_________________________________________________________________
News, entertainment and everything you care about at Live.com. Get it now!
http://www.live.com/getstarted.aspx