Return-Path: <linux-kernel-owner+w=401wt.eu-S1763184AbXLTNiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763184AbXLTNiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762553AbXLTNfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:35:09 -0500
Received: from smtp4-g19.free.fr ([212.27.42.30]:59981 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761805AbXLTNfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:35:04 -0500
Message-ID: <476A6F85.7070905@free.fr>
Date: Thu, 20 Dec 2007 14:35:01 +0100
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: neigh: timer & !nud_in_timer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I noticed the following message in my kernel log.
kernel: neigh: timer & !nud_in_timer
(Might be due to a race condition.)

I'm running a UP Linux version 2.6.22.1-rt9
( http://rt.wiki.kernel.org/index.php )

The following /proc entries might be relevant.

/proc/sys/net/ipv4/conf/all/arp_accept
0
/proc/sys/net/ipv4/conf/all/arp_announce
2
/proc/sys/net/ipv4/conf/all/arp_filter
0
/proc/sys/net/ipv4/conf/all/arp_ignore
1

I also lowered the priority of softirq-timer/0 to 10 which means
it can be interrupted by other IRQ handlers.

Regards.
