Return-Path: <linux-kernel-owner+w=401wt.eu-S934020AbXCFKdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020AbXCFKdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934018AbXCFKdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:33:18 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:37975 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934016AbXCFKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:32:59 -0500
Date: Tue, 6 Mar 2007 16:02:47 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Subject: BUG() during suspend to disk (2.6.21-rc2, x86_64)
Message-ID: <20070306103247.GA11002@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see following BUG() on serial console while hibernating on a x86_64
machine. I am using 2.6.21-rc2 kernel.


BUG: at arch/x86_64/kernel/acpi/sleep.c:70 init_low_mapping()

Call Trace:
 [<ffffffff80214b9a>] acpi_save_state_mem+0x70/0xd6
 [<ffffffff8036e90e>] acpi_pm_enter+0x23/0xc1
 [<ffffffff8024eec4>] pm_suspend_disk+0x1ac/0x228
 [<ffffffff8024dc9b>] enter_state+0x50/0x1e6
 [<ffffffff8036ecce>] acpi_system_write_sleep+0x5c/0x79
 [<ffffffff8027b767>] vfs_write+0xad/0x136
 [<ffffffff8027bca4>] sys_write+0x45/0x6e
 [<ffffffff80209bbe>] system_call+0x7e/0x83

Thanks
Vivek

