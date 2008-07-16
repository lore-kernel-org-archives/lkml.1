Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbYGPAdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbYGPAdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbYGPAdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:33:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:46923 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbYGPAdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:33:24 -0400
Message-ID: <cccedfc60807151733n1c204c73ya4878bc03cba2e26@mail.gmail.com>
Date: Tue, 15 Jul 2008 19:33:23 -0500
From: "Jon Nelson" <jnelson@jamponi.net>
To: linux-kernel@vger.kernel.org
Subject: request: via velocity and tg3 help
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a pair (each) of VIA Velocity and Broadcom (Altima) gig-e NICs.
They've never worked worth a damn. Only with 2.6.25.5 (and later) does
the VIA not kernel oops on boot, but neither one of them works
correctly, and things go downhill even faster when jumbo frames get
involved. They are both OK in 100-mbit, but in gig-e nearly useless. I
am willing to personally ship one or both cards to parties interested
in making them work better. I also have a single RTL8169-based card
which works OK but not great, and I may be willing to do the same
there. The only gig-e NICs I have are NVidia (Marvell) MCP55 which, at
least as of 2.6.25.9, work great - I'm easily able to sustain 112MB/s
with 1500byte frames and a non-jumbo-frame capable Intel NIC.

Part of the reason I'm interested in getting these to work is that the
overwhelming majority of the lower-cost Gig-E cards appear to use the
VIA chipset, and the RTL8169 is the next-most popular before the
Intel. OEMs, of course, use the Broadcom/Altima extensively. Having a
viable gig-e card that can handle jumbo frames (the VIA handles up to
7200, the other two claim to handle up to 9000) for cheap is a big win
for some people.

The cards identify as:

(2x) Altima (nee Broadcom) AC9100 Gigabit Ethernet (rev 15)
(2x) VIA Technologies, Inc. VT6120/VT6121/VT6122 Gigabit Ethernet
Adapter (rev 11)
(1x) RTL8110s at 0xd0866f00, 00:40:f4:ef:6c:df, XID 04000000 IRQ 17

-- 
Jon
