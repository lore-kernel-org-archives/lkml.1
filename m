Return-Path: <linux-kernel-owner+w=401wt.eu-S933382AbXCIVsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbXCIVsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933388AbXCIVsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:48:23 -0500
Received: from imo-m21.mx.aol.com ([64.12.137.2]:47768 "EHLO
	imo-m21.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933382AbXCIVsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:48:22 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2007 16:48:22 EST
References: <8C930983B0855DF-1728-4769@webmail-dd15.sysops.aol.com>
To: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Subject: TCP MSG_PEEK kernel assertions ...
Date: Fri, 09 Mar 2007 16:43:10 -0500
In-Reply-To: <8C930983B0855DF-1728-4769@webmail-dd15.sysops.aol.com>
X-MB-Message-Source: WebUI
MIME-Version: 1.0
From: davef1624@aol.com
X-MB-Message-Type: User
Content-Type: text/plain; charset="us-ascii"; format=flowed
X-Mailer: AOL WebMail 24126
Message-Id: <8C930AB112CB842-1728-4DAC@webmail-dd15.sysops.aol.com>
X-AOL-IP: 205.188.104.15
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


 Hello,

  I periodically see the following TCP kernel assertion errors in 
/var/log/message
  (it does seem that networking is eventually able to recover from these 
errors):

  kernel: KERNEL: assertion (flags & MSG_PEEK) failed at net/ipv4/tcp.c 
(1171)
  kernel: KERNEL: assertion (flags & MSG_PEEK) failed at net/ipv4/tcp.c 
(1171)
  kernel: KERNEL: assertion (tp->copied_seq == tp->rcv_nxt || (flags & 
(MSG_PEEK | MSG_TRUNC))) failed at net/ipv4/tcp.c (1235)
  kernel: KERNEL: assertion (flags & MSG_PEEK) failed at net/ipv4/tcp.c 
(1171)
  kernel: KERNEL: assertion (tp->copied_seq == tp->rcv_nxt || (flags & 
(MSG_PEEK | MSG_TRUNC))) failed at net/ipv4/tcp.c (1235)

  These errors only seem to occur when using the sk98lin (SysKonnect) 
Network Device Driver,
  and a Yukon Gigabit Ethernet 10/100/1000Base-T Adapter (from Marvell I 
believe).
 (The other NIC cards we're using in-house don't exhibit this issue).

 I've seen postings concerning this issue over the past year or so,
  but have not seen a clear resolution and/or understanding of the 
root-cause of this issue.

  I'm in the process of upgrading my sk98lin network driver to the 
latest from SysKonnect
 in an attempt to see if this corrects the problem.

 Does anybody have any insight into this problem?

 Best regards,
 Dave F


  
________________________________________________________________________ 

  AOL now offers free email to everyone. Find out more about what's free 
from AOL at AOL.com.
 -
  To unsubscribe from this list: send the line "unsubscribe linux-net" 
in
 the body of a message to majordomo@vger.kernel.org
 More majordomo info at http://vger.kernel.org/majordomo-info.html


________________________________________________________________________
AOL now offers free email to everyone.  Find out more about what's free 
from AOL at AOL.com.
