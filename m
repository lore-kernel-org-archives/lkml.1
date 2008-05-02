Return-Path: <linux-kernel-owner+w=401wt.eu-S933879AbYEBBYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933879AbYEBBYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758021AbYEBBXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:23:49 -0400
Received: from vps1.tull.net ([66.180.172.116]:40671 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758789AbYEBBXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:23:47 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Fri, 2 May 2008 11:23:37 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Alex Davis <alex14641@yahoo.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Sharing disks amoung multiple software RAIDs
Message-ID: <20080502012337.GD13463@tull.net>
References: <771640.4981.qm@web50209.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <771640.4981.qm@web50209.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 04:35:07AM -0700, Alex Davis wrote:
> Is this a bad thing? I'm guessing that it is, but I want independent
> confirmation before I spoke to someone I know who's doing this.

I use it to ensure that multiple partitions are RAIDed. I have a /boot
partition which is ext3 and a large LVM partition. Both of them are
RAID-1 onto a second drive (md0 and md1) for redundancy. The second
drive has an identical partition table to the first drive.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
