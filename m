Return-Path: <linux-kernel-owner+w=401wt.eu-S1759827AbYJIPI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827AbYJIPI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 11:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbYJIPIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 11:08:21 -0400
Received: from bytemail.bytemark.co.uk ([80.68.81.165]:57664 "EHLO
	bytemail.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbYJIPIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 11:08:20 -0400
X-Greylist: delayed 1529 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Oct 2008 11:08:20 EDT
Message-ID: <48EE1867.1070003@bytemark.co.uk>
Date: Thu, 09 Oct 2008 15:42:47 +0100
From: Alex Howells <alex@bytemark.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: r8169 counters, Intel Atom 230 (D945GCLF)
X-Enigmail-Version: 0.95.0
OpenPGP: id=B188A23A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Afternoon,

We ran into a lot of issues with the Intel Atom (D945GCLF) boards
shortly after they were released, particularly to do with network
booting the systems with x86_64 kernel via PXE and TFTP.

These seem to be fixed very nicely in the latest 2.6.27-rc kernels!

However I've just spotted an odd issue:

eth0      Link encap:Ethernet  HWaddr 00:1C:C0:5F:DC:02
          inet addr:89.16.177.251  Bcast:89.16.177.255  Mask:255.255.255.0
          inet6 addr: fe80::21c:c0ff:fe5f:dc02/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:25218 errors:0 dropped:2758040992 overruns:0 frame:0
          TX packets:23301 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:18615148 (17.7 Mb)  TX bytes:3597444 (3.4 Mb)
          Interrupt:124

That box was literally just booted about 30 seconds previously, and
whilst the RX packets/bytes looks believable the 'dropped' counter is
totally out of this world.

Any ideas?

Cheers,
Alex
