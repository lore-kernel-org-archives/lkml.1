Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYAXQxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYAXQxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYAXQxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:53:06 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:64181 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbYAXQxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:53:03 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 00/17] [MIPS] Malta: massive code cleanup
Date: Thu, 24 Jan 2008 19:52:40 +0300
Message-Id: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf,

This is the Malta cleanup, which I was talking about some time ago.

The patches should be fairly obvious. They make no functional
changes.

Build tests passed successfully when I used the default configs
for Atlas, Malta and SEAD.

Just in case, I also ran boot tests, which passed successfully with
the default Malta config and a Qemu-emulated Malta board in both BE
and LE modes.

The net effect is that the number of errors, warnings, and checks
reported by checkpatch.pl changes as follows:

Before:

--------------------------------------------
              | errors | warnings | checks 
--------------------------------------------
malta_int.c   |  47    |    20    |    1   
--------------------------------------------
malta_setup.c |  3     |    21    |    3
--------------------------------------------
malta_smtc.c  |  2     |    0     |    0
--------------------------------------------

After:

--------------------------------------------
              | errors | warnings | checks 
--------------------------------------------
malta_int.c   |  0     |    0     |    0   
--------------------------------------------
malta_setup.c |  0     |    0     |    0
--------------------------------------------
malta_smtc.c  |  0     |    0     |    0
--------------------------------------------

The last patch in the series removes a very obsolete and misleading
document from Documentation/mips.

Please consider.

Thanks,

Dmitri
