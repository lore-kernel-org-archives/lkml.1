Return-Path: <linux-kernel-owner+w=401wt.eu-S965217AbXCQNBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965217AbXCQNBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 09:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933826AbXCQNBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 09:01:20 -0400
Received: from bay0-omc3-s38.bay0.hotmail.com ([65.54.246.238]:37780 "EHLO
	bay0-omc3-s38.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933823AbXCQNBT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 09:01:19 -0400
Message-ID: <BAY103-DAV1484A3797D5368C28969CBB2700@phx.gbl>
X-Originating-IP: [85.41.109.158]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: "David Chinner" <dgc@sgi.com>
Cc: "David Chinner" <dgc@sgi.com>, <linux-kernel@vger.kernel.org>,
       <xfs@oss.sgi.com>
References: <BAY103-DAV1066400DF0615AD677EA1B2730@phx.gbl> <20070316012520.GN5743@melbourne.sgi.com> <BAY103-DAV13EC09E9BCB3E8C9D5EEA2B2710@phx.gbl> <20070316195951.GB5743@melbourne.sgi.com>
Subject: Re: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller 0xc01b00bd
Date: Sat, 17 Mar 2007 14:00:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2180
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2180
X-OriginalArrivalTime: 17 Mar 2007 13:01:19.0230 (UTC) FILETIME=[5ADE11E0:01C76894]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:

> Ok, so an ipsec change. And I see from the history below it
> really has nothing to do with this problem. it seems the problem
> has something to do with changes between 2.6.19.1 and 2.6.19.2.

indeed. Yesterday at 13:00 I have switched from 2.6.19.1 to 2.6.19.2
(without the ipsec fix) and at about 17:30 linux has crashed again.
I have recompiled 2.6.19.2 with all kernel debugging options enabled
and rebooted. Now I'm waiting for the crash...

> There were no changes to XFS between 2.6.19.1 and 2.6.19.2,
> so I'm thinking that your problems are related to something
> other than XFS. Can you do a git bisect to determine what the
> bad patch is?

Ok, monday morning I will try to do a git bisect. I just want tell you
that this machine is a firewall (3 nic) + ipsec gateway (openswan) +
http proxy (squid). I think that the problem is related to the networking.
I have other 2.6.19/2.6.20 linux boxes acting as proftpd/samba/sendmail
without any problem.

>> > Can you run xfs_repair on that filesystem and see if reports
>> > (and fixes) any problems?
>> 
>> I don't need to run xfs_repair to fix the problem,
> 
> Except that the trigger might be on-disk corruption so we
> need to rule that out first.

Ok I will run xfs_repair and post results.

>> I only unplug the power cable and reboot the system,
>> xfs filesystem are correctly mounted.
>> However tell me if I must run xfs_repair to check
>> the filesystem.
> 
> Yes, you need to run xfs_repair.

ok , thanks a lot for the feedback.

PS: I'm running slackware 11 with xfsprogs-2.8.10. Are they fine
or should I upgrade?
