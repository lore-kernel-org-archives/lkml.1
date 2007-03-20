Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbXCTMOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbXCTMOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 08:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbXCTMOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 08:14:50 -0400
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:36842 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbXCTMOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 08:14:49 -0400
Message-ID: <45FFCF31.3040000@bx.jp.nec.com>
Date: Tue, 20 Mar 2007 21:10:25 +0900
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 1.5.0.4 (Windows/20060516)
MIME-Version: 1.0
To: mpm@selenic.com
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC][PATCH -mm take3 0/6][resend] proposal for dynamic configurable
 netconsole
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keiichi KII <k-keiichi@bx.jp.nec.com>

The netconsole is a very useful module for collecting kernel message under
certain circumstances(e.g. disk logging fails, serial port is unavailable).

But current netconsole is not flexible. For example, if you want to change ip
address for logging agent, in the case of built-in netconsole, you can't change
config except for changing boot parameter and rebooting your system, or in the
case of module netconsole, you need to remove it and reload with different
parameters.

So, I propose the following extended features for netconsole.

1) support for multiple logging agents.
2) add interface to access each parameter of netconsole
   using sysfs.

[changes since take2]
-changing kernel base from 2.6.20-rc1-mm1 to 2.6.21-rc3.mm2.
-using symbolic link for network device.
-changing in part interface from sysfs to ioctl,
 because Stephen Hemminger advised us that it is a misuse that
 sysfs has the behavior with magic side effect such as adding/removing port.

This patch is for linux-2.6.21-rc3-mm2 and is divided to each function.
Your comments are very welcome.

Signed-off-by: Keiichi KII <k-keiichi@bx.jp.nec.com>
Signed-off-by: Takayoshi Kochi <t-kochi@bq.jp.nec.com>
---


