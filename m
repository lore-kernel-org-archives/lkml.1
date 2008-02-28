Return-Path: <linux-kernel-owner+w=401wt.eu-S1763690AbYB1U0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763690AbYB1U0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762302AbYB1U0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:26:22 -0500
Received: from mail.tmr.com ([64.65.253.246]:52578 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761987AbYB1U0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:26:20 -0500
Message-ID: <47C719CB.6070704@tmr.com>
Date: Thu, 28 Feb 2008 15:30:03 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Mariella Petrini <mariellapetrini@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux and SSD and how to decrease io delay : question, please
References: <847418.75727.qm@web35715.mail.mud.yahoo.com>
In-Reply-To: <847418.75727.qm@web35715.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mariella Petrini wrote:
> Hi All,
> 
> I have been running Linux kernel 2.6.23 with Debian on
> 
> a 2 CPUs Dual-Core AMD Opteron(tm) Processor 2218.
> I have been using an SSD drive (MTRON) connected to a
> raid controller (LSI      MegaRAID 8704ELP) to contain
> data stored on several databases.
> Each database contains 20,000 files and there are 50
> databases total (1,000,000 files distributed across 50
> directories on the filesystem on the ssd).
> 
> The database server uses the databases very "write"
> intensively.
> An approximate percentage could be 20% reads versus
> 80% random writes.
> 
> No matter which filesystem type is used (I have tried
> ext3, xfs, jfs, reiserfs) I see every few seconds
> snapshots (the could last in the worst case up to 200
> seconds, depending on the filesystem type) 
> where the iowait on the ssd device goes approximately
> over 50% (up to 100%) and 
> the database server threads go to wait (get
> suspended).
> 
> Is there any Linux kernel parameter or any Linux
> parameter that could be varied that could help to
> decrease the time spent to sync all the data to the
> SSD device ?
> 
I may misunderstand the problem, but have you tried tuning the 
parameters /proc/sys/vm/dirty_* to help this? It sounds as if you may be 
filling write cache and then flushing. Of course you didn't measure the 
disk i/o rates along with this, so it's hard to see what's happening.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
