Return-Path: <linux-kernel-owner+w=401wt.eu-S964933AbXIKWMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964933AbXIKWMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 18:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXIKWMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 18:12:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbXIKWMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 18:12:48 -0400
Message-ID: <46E7111B.2050303@ncsu.edu>
Date: Tue, 11 Sep 2007 18:05:15 -0400
From: Casey Dahlin <cjdahlin@ncsu.edu>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [BUG:] forcedeth: MCP55 not allowing DHCP
References: <20070908200523.GA16204@askeshav-devel.jf.intel.com> <18148.12140.21118.252581@cargo.ozlabs.ibm.com> <20070911174231.GC24627@askeshav-devel.jf.intel.com> <20070912192854.GA32610@askeshav-devel.jf.intel.com> <18150.61732.490669.269794@cargo.ozlabs.ibm.com> <20070912215523.GA510@askeshav-devel.jf.intel.com>
In-Reply-To: <20070912215523.GA510@askeshav-devel.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
