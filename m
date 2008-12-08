Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbYLHIMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbYLHIMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 03:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYLHIMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 03:12:41 -0500
Received: from i220-221-252-159.s30.a048.ap.plala.or.jp ([220.221.252.159]:59052
	"EHLO mail.m.clustcom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751050AbYLHIMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 03:12:41 -0500
Date: Mon, 8 Dec 2008 17:12:30 +0900
From: Hitoshi Mitake <mitake@clustcom.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ktaka@clustcom.com
Subject: [RFC] New functions to manipulate registers for ethtool
Message-Id: <20081208171230.288c5ccf.mitake@clustcom.com>
Organization: Cluster Computing, Inc
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi

I want to add two new functions to ethtool.

One is for setting driver's registers on MMIO area like --change-eeprom option.
I think form of command line is like this,
ethtool -X|--set-register ethX [offset N(in bytes)] [value N(single byte value)]

Another function is for reading driver's register on MMIO.
Currently, there is --register-dump option for dumping registers.
But I want finer granularity one which unit of manipulation is byte.
Like this,
ethtool -B|--dump-register-byte ethX [offset N(in bytes)]
(then print one byte to stdout)

Of course, names of options is temporary.

Because e1000e driver conflicts with some IPMI cards some time,
and the reasons of conflict are setting of registers not supported by
other general options of ethtool.
If this function is added, examing cause of confliction will be much easier.

How do you think about this plan?
If this plan is not bad, and nobody is working on patch like this plan,
I want to do that.

Thanks

Hitoshi
