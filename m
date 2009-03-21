Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZCUGu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZCUGu3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 02:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZCUGuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 02:50:14 -0400
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:52085
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZCUGuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 02:50:13 -0400
Date: Sat, 21 Mar 2009 15:50:06 +0900
From: Mattia Dongili <malattia@linux.it>
To: linux-wireless@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       reinette.chatre@intel.com, yi.zhu@intel.com, linville@tuxdriver.com
Subject: iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms
Message-ID: <20090321065006.GF3834@kamineko.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.26-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I get this error consistently with all the recent kernels:
[  338.476057] iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
[  458.976089] iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
[  598.885036] iwl3945: Microcode SW error detected.  Restarting 0x82000008.
[  598.885050] iwl3945: Error Reply type 0x00000005 cmd REPLY_TX (0x1C) seq 0x02AC ser 0x0000004E
[  601.869319] iwl3945: Can't stop Rx DMA.
then the wifi connection becomes useless and I have to re-associate to
the AP or sometimes to unload and reload the module to get my connection
back.

The above is on 2.6.29-rc8 but I get it since 2.6.28 (apologies for not
reporting it earlier).  Both my thinkpad x60s and my vaio sz72b are
affected.
Reproducing it is very easy, I just need to download even a small file.

After reading some older bug submissions I rebuilt the driver with debug
support and loaded it with debug=0x43fff, the log is here:
http://kamineko.org/kernel/kern.log
The beginning of the log is 2.6.28 with no debug, then you can see a
reboot and the module loaded with the debug option on 2.6.29-rc8.

Is this a known problem? Is there any other information I can provide to
help fixing it?

Thanks
-- 
mattia
:wq!
