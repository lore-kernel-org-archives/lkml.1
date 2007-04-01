Return-Path: <linux-kernel-owner+w=401wt.eu-S933862AbXDASnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862AbXDASnW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933860AbXDASnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:43:22 -0400
Received: from smtpout.mac.com ([17.250.248.185]:62058 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933848AbXDASnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:43:21 -0400
In-Reply-To: <Pine.LNX.4.61.0704012010530.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704012010530.12316@yvahk01.tjqt.qr>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <408FF8B5-A6A8-479A-B60A-37A219B5FCB1@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jouni Malinen <jkmaline@cc.hut.fi>, Jeroen Vreeken <pe1rxq@amsat.org>,
       Andrew Morton <akpm@osdl.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH 15/16] use-regular-eth-suffix.diff
Date: Sun, 1 Apr 2007 14:42:39 -0400
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 01, 2007, at 14:18:12, Jan Engelhardt wrote:
> Some radio adapter drivers wrongly(?) name their devices "wlan%d"  
> instead of "eth%d" (if you ask me, it should be %u - but not today).
>
> Technically, they operate like Ethernet, and in fact, running `/ 
> sbin/ip a` shows "link/ether" instead of "link/ieee80211". This  
> patch renames them back, but I would appreciate some comment,  
> explanation or at least link why they actually have wlan%d there.

NACK.  This has the potential to significantly break backwards- 
compatibility for users of those cards who are not using udev to  
maintain consistent device naming (because they only have a single  
card, for example).  I would recommend against applying it for that  
reason.

Cheers,
Kyle Moffett

