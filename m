Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbXKAV6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbXKAV6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 17:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbXKAV6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 17:58:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45568
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753485AbXKAV63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 17:58:29 -0400
Date: Thu, 01 Nov 2007 14:58:28 -0700 (PDT)
Message-Id: <20071101.145828.36424380.davem@davemloft.net>
To: djohnson+linux-kernel@sw.starentnetworks.com
Cc: greearb@candelatech.com, shemminger@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bguo@sw.starentnetworks.com
Subject: Re: expected behavior of PF_PACKET on NETIF_F_HW_VLAN_RX device?
From: David Miller <davem@davemloft.net>
In-Reply-To: <18218.18134.353553.189622@zeus.sw.starentnetworks.com>
References: <20071031.215025.195350296.davem@davemloft.net>
	<4729EAFF.9050606@candelatech.com>
	<18218.18134.353553.189622@zeus.sw.starentnetworks.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
Date: Thu, 1 Nov 2007 17:36:22 -0400

> bad csum on tx packets as reported by tcpdump is also an issue.

We provide a tag to userspace that tcpdump should use to see that the
HW is going to checksum the packet, and therefore it should elide
trying to verify the checksums.

It's not a kernel issue.
