Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbXFMDY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbXFMDY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 23:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbXFMDYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 23:24:48 -0400
Received: from sandeen.net ([209.173.210.139]:22423 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbXFMDYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 23:24:47 -0400
Message-ID: <466F6380.2010800@sandeen.net>
Date: Tue, 12 Jun 2007 22:24:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: Re: [GIT PATCH] sysfs fixes for 2.6.22-rc4
References: <20070612232159.GA12971@suse.de>
In-Reply-To: <20070612232159.GA12971@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> Eric Sandeen (1):
>       sysfs: store sysfs inode nrs in s_ino to avoid readdir oopses

To be fair, Tejun wrote that one too, I just backported & tried to
simplify it a bit for -stable.  :)

> Tejun Heo (2):
>       sysfs: fix condition check in sysfs_drop_dentry()
>       sysfs: fix race condition around sd->s_dentry, take#2
> 

Glad to see these are making their way out, we've had people hit these
bugs too.  And they beat on this basic patchset quite a lot, with good
results.

Thanks!

-Eric
