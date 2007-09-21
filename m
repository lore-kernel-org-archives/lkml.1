Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbXIUDrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbXIUDrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 23:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbXIUDrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 23:47:33 -0400
Received: from uni21mr.unity.ncsu.edu ([152.1.2.137]:61479 "EHLO
	uni21mr.unity.ncsu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbXIUDrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 23:47:32 -0400
Message-ID: <46F33ED0.9080808@ncsu.edu>
Date: Thu, 20 Sep 2007 23:47:28 -0400
From: Casey Dahlin <cjdahlin@ncsu.edu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [Fwd: [BUG:] forcedeth: MCP55 not allowing DHCP]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.313940, Antispam-Data: 2007.9.20.202046
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently I posted this in the middle of an unrelated thread by 
mistake. If this is the third message you are getting in regard to this 
issue, sorry :( Just trying to get it in the right place.

-------- Original Message --------
Subject: 	[BUG:] forcedeth: MCP55 not allowing DHCP
Date: 	Tue, 11 Sep 2007 18:05:15 -0400
From: 	Casey Dahlin <cjdahlin@ncsu.edu>
To: 	Linux Kernel <linux-kernel@vger.kernel.org>

	


I have an Asus Striker Extreme motherboard with two built in MCP55 GigE 
interfaces. When I build with the original Fedora 7 release kernel ( 
ftp://ftp.belnet.be/linux/fedora/linux/releases/7/Fedora/i386/os/Fedora/kernel-2.6.21-1.3194.fc7.i686.rpm 
) everything works fine. However, when I boot with any updated kernels 
or any other kernel (have tried building from several points in the 
linus git tree between 2.6.20 and .23-rc3, and 2.6.21.2 in -stable) I 
cannot get an IP address via dhcp. There is no error in dmesg. The card 
shows a link and otherwise appears to be working, but it is as if the 
dhcp server has been removed from the network.

On a running system there is no indication that this is a kernel bug at 
all, however by varying only the kernel the bug appears and disappears. 
I've run all these tests repeatedly with no intervening updates of any 
other packages.

As I said I attempted to build 2.6.21.2 ( the point of divergence 
between the Fedora kernel in question and -stable ) and still the card 
did not work. I will next attempt to manually build the rpm for the 
release kernel. If this works I will try experimenting with the included 
patches to narrow it down, but at this point I'm at a complete loss.

-Casey Dahlin
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

