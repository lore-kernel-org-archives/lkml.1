Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbXJXLJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbXJXLJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbXJXLJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:09:16 -0400
Received: from turtle-out.mxes.net ([216.86.168.191]:3174 "EHLO
	turtle-out.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbXJXLJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:09:15 -0400
X-Greylist: delayed 1583 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 07:09:15 EDT
Message-ID: <32892.86.7.220.119.1193222572.squirrel@wmbeta.mxes.net>
Date: Wed, 24 Oct 2007 11:42:52 +0100 (BST)
Subject: 2.6.24-rc1: NULL pointer dereference using netconsole
From: "Andrew Nelless" <andrew@nelless.net>
To: linux-kernel@vger.kernel.org
Reply-To: "Andrew Nelless" <andrew@nelless.net>
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I booted up 2.6.24-rc1 this morning [Real early over a brew ;-)] and was
having a problems with multiple ~5 second hangs on SATA/drive init
(Something to do with "EH" something-or-other and resets but I'll email
in separately about it later unless its fixed by the time I get the chance).

Anyway, I went to fire up netconsole to get a decent log dump and hit
across the following nasty. Netconsole works fine in 2.6.23.1 with a
similar config and the same kernel parameters.

A shot of the screen is the only method I could come up with to capture
the log, I hope that is OK, it is pretty readable.


The nasty:
http://andotnet.nfshost.com/linux/2.6.24-rc1-netconsole-nullderef.jpg

The config:
http://andotnet.nfshost.com/linux/config-2.6.24-rc1.txt

The 'old' 2.6.23.1 config:
http://andotnet.nfshost.com/linux/config-2.6.23.1.txt

Netconsole log from successfully booting 2.6.23.1:
http://andotnet.nfshost.com/linux/successful-nclog-2.6.23.1.txt

The hardware, etc:
eth0          : Netgear FA311 10/100Mbps ethernet adapter (netsemi driver)
                connected directly to another PC using a crossover cable.
cpu           : athlon64 3500+
compiler      : gcc 4.2.2
kernel params : root=/dev/sda3 vga=0x31B nmi_watchdog=0
                netconsole=@192.168.2.1/eth0,6666@192.168.2.2/00:11:d8:c0:5e:96


I hope this report is helpful and it's not too early in the release cycle,
I'm still pretty new and not subscribed, so please CC :-)

Btw, is it preferable for non-subscribers to use the kernel bugzilla? Or
post to the list?


Andrew (On his 3rd brew of the day)

