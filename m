Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbXKBTK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbXKBTK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 15:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbXKBTKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 15:10:18 -0400
Received: from mailgate.ics.forth.gr ([139.91.1.2]:53141 "EHLO
	mailgate.ics.forth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbXKBTKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 15:10:17 -0400
X-Greylist: delayed 4189 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2007 15:10:17 EDT
Message-ID: <47768.139.91.70.143.1194026426.squirrel@webmail.ics.forth.gr>
Date: Fri, 2 Nov 2007 20:00:26 +0200 (EET)
Subject: Error in __bread reading a 4K block from a SATA device
From: "Thanos McAtos" <mcatos@ics.forth.gr>
To: "lkml " <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to read a 4KB block using __bread from a SATA device but I get
the following error:

__find_get_block_slow() failed. block=1, b_blocknr=0
b_state=0x00000029, b_size=4096

If I try to read a 2K block (which is the hard sector size of the device),
it works fine.

Kernel version is 2.6.20.21. I have used this function at another system but
the device from which I read was an IDE one and it's hard sector size was
512 bytes. I've also tested this at a 2.6.18.8 kernel.

The old device was at a 32bit system, the new one is at a 64bit one.

What could be wrong?

Thanx in advance.



