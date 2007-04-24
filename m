Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbXDXFCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbXDXFCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbXDXFCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:02:08 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:17422 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbXDXFCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:02:07 -0400
Date: Mon, 23 Apr 2007 23:02:01 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: BUG/CRASH help - 2.6.20 (fc5) - spinlock bad magic on CPU#0, kswapd
In-reply-to: <fa.zMzheLQy67ZMGEuuN/3CmN/fQpQ@ifi.uio.no>
To: Ian Kirk <intercede619@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <462D8F49.60103@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.zMzheLQy67ZMGEuuN/3CmN/fQpQ@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kirk wrote:
> Hi,
> 
> I just wondered if the below type of crash was a known thing, and if
> there are any obvious things I can do to prevent/fix it ?
> 
> BUG: spinlock bad magic on CPU#0, kswapd0/242 (Not tainted)
> lock: c06c9380, .magic: c06c9380, .owner:
> [<c06eba2a>] _raw_spin_lock+0x1a/0xd9
> [<c061e72f>] _spin_lock_irqsave+0x9/0xd
> [<c041febf>] __wake_up+0x18/0x43
> [<c04379ce>] __wake_up_bit+0x2e/0x33
> [<c045a496>] shrink_inactive_list+0x483/0x6c9

RAM issues are a possibility for this sort of problem, tried running 
Memtest86+?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

