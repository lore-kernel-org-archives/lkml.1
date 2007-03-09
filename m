Return-Path: <linux-kernel-owner+w=401wt.eu-S1767616AbXCIXGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767616AbXCIXGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767619AbXCIXGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:06:43 -0500
Received: from imo-d21.mx.aol.com ([205.188.144.207]:53938 "EHLO
	imo-d21.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767616AbXCIXGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:06:42 -0500
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2007 18:06:42 EST
To: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Subject: TCP MSG_PEEK assertion issue ...
Date: Fri, 09 Mar 2007 18:01:31 -0500
X-MB-Message-Source: WebUI
MIME-Version: 1.0
From: davef1624@aol.com
X-MB-Message-Type: User
Content-Type: text/plain; charset="us-ascii"; format=flowed
X-Mailer: AOL WebMail 24126
Message-Id: <8C930B602E0D30D-1728-50C9@webmail-dd15.sysops.aol.com>
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
AOL now offers free email to everyone.  Find out more about what's free 
from AOL at AOL.com.
