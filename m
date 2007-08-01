Return-Path: <linux-kernel-owner+w=401wt.eu-S1764217AbXHATki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764217AbXHATki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 15:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761632AbXHATka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 15:40:30 -0400
Received: from uosis.mif.vu.lt ([193.219.42.14]:3850 "EHLO uosis.mif.vu.lt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761592AbXHATka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 15:40:30 -0400
X-Greylist: delayed 1953 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Aug 2007 15:40:30 EDT
Date: Wed, 1 Aug 2007 22:07:54 +0300
From: Rokas Masiulis <roma1390@uosis.mif.vu.lt>
To: linux-kernel@vger.kernel.org
Subject: Examine user space locks
Message-ID: <20070801190754.GA31656@uosis.mif.vu.lt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Organization: VU MIF
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

sometimes user space program hangs forever.
In old days i remeber there was unkillable dosemu.
May be there are good how to. Some one can point to it?

This is problem/solution isn't related to current kernel. This
is question: what to do in this sitaution. 

Now i have eject(1)

 $ ps uax | grep eject
 root     12662  0.0  0.0   1528   560 ?        D    Jul31   0:00 eject
 root     12866  0.0  0.0   1532   560 pts/10   D    Jul31   0:00 eject
 $ date
 Wed Aug  1 21:56:59 EEST 2007

That same eject worked on that same hardware and kernel before.

 # strace -p 12662
 Process 12662 attached - interrupt to quit

dosn't show which syscall is called.

kill -9 12662 doesn't help to.

No ops, no other info in dmesg.

How to find problem? How to kill/stop proces without reboot?
How to find which lock is taken by kernel to complete user space
request/syscalls? 

kernel: 2.6.17-gentoo-r4-20061014-00
dmesg: http://89.190.108.145/~rokas/dmesg.txt
config: http://89.190.108.145/~rokas/config.txt

Thanks for any hints.

roma139
