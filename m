Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbZD0FmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbZD0FmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 01:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZD0FmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 01:42:13 -0400
Received: from night.yars.free.net ([193.233.48.54]:44293 "EHLO
	night.yars.free.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbZD0FmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 01:42:12 -0400
Date: Mon, 27 Apr 2009 09:41:03 +0400
From: "Alexander V. Lukyanov" <lav@netis.ru>
To: linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org
Subject: Re: 2.6.29.1: unregister_netdevice problem
Message-ID: <20090427054103.GA27529@night.netis.ru>
References: <20090422055735.GA4334@night.netis.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422055735.GA4334@night.netis.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 09:57:35AM +0400, Alexander V. Lukyanov wrote:
> unregister_netdevice: waiting for eth0.2 to become free. Usage count = 4
> 
> eth0.2 is a vlan interface, eth0 is 02:00.0 Ethernet controller: Realtek
> Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet
> controller (rev 01)

Ok, now I did manually 'vconfig rem eth0.2' and I get these repeated messages.
How do I find out what exactly holds the interface being used?

I have killed most of non-kernel processes, eth0.2 is still used. LA=1, but
the cpu is idle.

top - 09:34:26 up 4 days, 23:55,  2 users,  load average: 1.00, 1.12, 3.55
Tasks:  56 total,   1 running,  55 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.2%us,  0.2%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   3356308k total,  1165044k used,  2191264k free,   443536k buffers
Swap:  3212920k total,      712k used,  3212208k free,   493568k cached

-- 
   Alexander..
