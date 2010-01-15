Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab0AOJRL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684Ab0AOJRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:17:10 -0500
Received: from eazy.amigager.de ([213.239.192.238]:47795 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab0AOJRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:17:08 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jan 2010 04:17:08 EST
Date: Fri, 15 Jan 2010 10:10:53 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Regression: Wake on LAN doesn't work in sky2 with 2.6.33-rc4-git2
Message-ID: <20100115091053.GA5477@mac.home>
Mail-Followup-To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

wake on LAN doesn't work with 2.6.33-rc4-git2 on the following
hardware:

01:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd.
88E8053 PCI-E Gigabit Ethernet Controller [11ab:4362] (rev 22)

It worked with 2.6.32. In my suspend script, I enable WoL using
ethtool:

ethtool -s eth0 wol g

in dmesg, I get these messages at suspend:

sky2 eth0: disabling interface
sky2 0000:01:00.0: PME# enabled
sky2 0000:01:00.0: wake-up capability enabled by ACPI

and at resume:

sky2 0000:01:00.0: wake-up capability disabled by ACPI
sky2 0000:01:00.0: PME# disabled

Regards,
Tino
