Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYFAW7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYFAW7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 18:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYFAW6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 18:58:54 -0400
Received: from hope.ime.usp.br ([143.107.45.8]:60361 "HELO hope.ime.usp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752391AbYFAW6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 18:58:54 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jun 2008 18:58:53 EDT
Date: Sun, 1 Jun 2008 16:30:01 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org
Subject: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080601193000.GA3056@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: 71499546ac1efa011376f4e57875b6c6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I have an iBook G3 600MHz combo (late 2001 model, powerpc) with a USB
wireless card rt2x00 that doesn't work.

I just compiled a fresh 2.6.26-rc4 kernel and it can't get a lease from
the access point, even though it is able to see the access point.

The userland here is Debian unstable (sid) and I can perform some of the
steps in the direction of configuring the interface. For instance, the
following works (I am using wep as the encryption system with other systems
running under Linux, but, unfortunately, EVEN disabling encryption for the
sake of the tests doesn't help here):

*insert USB card*
ifconfig wlan0 up
iwconfig wlan0 essid "default"
iwconfig wlan0 s:my-key
iwconfig wlan0 ap any
(Here it shows that it can see the access point)
dhclient wlan0
(Here, it is unable to grab an IP addess from the access point)

I have all the information available (like the revision of my USB
device) for any developer that could help me in eliminating this bug
from the kernel on big-endian architectures.


Thanks in advance, Rogério.

P.S.: I am not currently subscribed to linux-kernel, so I would
appreciate any copies of the replies. Thanks.
-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
