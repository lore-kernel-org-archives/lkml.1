Return-Path: <linux-kernel-owner+w=401wt.eu-S1946610AbXBIRZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946610AbXBIRZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946638AbXBIRZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:25:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:53374 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946610AbXBIRZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:25:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=t63kyodTSWZ/2+qnzfzGfR+Nn+oM4l1LWV0zmSdrCPIA0rfJyuQN0JQlFu3IqKD3fe7OCG9j6IE8LEEjldqaMaxlm/26LifPMmC9Y005W57t7Na0hxcbJwGtQaoAO456R/ZAgVRX4pVCJds/nQuW6x3u23/nTcFA4KfoQbWOQgA=
Message-ID: <97c001730702090925ybc5566erc8dd1e13272b7cd4@mail.gmail.com>
Date: Fri, 9 Feb 2007 11:25:29 -0600
From: Meher <mail2meher@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Serial console input problem
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
     I am porting linux version 2.6.10 to a MIPS(Big Endian) based
custom board. I am able to boot the kernel and get the root file
system in flash mounted and start init successfully. I can see
messages from init (busybox based) on the serial console but for some
reason I am not able to enter any data on the serial console. Output
to the console works fine but input does not seem to work. There is no
problem with the serial port because from boot loader I am able to
read user input through serial port and boot accordingly.
    This is my kernel command line:

console=ttyS0,9600n81 root=/dev/mtdblock3 rootfstype=jffs2 rw

I tried starting /bin/sh instead of init to ensure I can enter
something on shell but these are the messages I get from kernel:

~~~~~~~~~~~~~~
Found a mtd2 image (0x0), with size (0x20000).
Creating 1 MTD partitions on "Primary flash device":
0x00000000-0x00020000 : "mtd2"
Number of partitions detected: 3
mice: PS/2 mouse device common for all mice
VFS: Mounted root (jffs2 filesystem).
Freeing unused kernel memory: 96k freed
Kalyan:: going into serial_link_irq_chain
Kalyan:: Going into request_irq with irq number: 15
kalyan::Running /bin/sh
Algorithmics/MIPS FPU Emulator v1.5


BusyBox v1.00 (2007.02.05-19:57+0000) Built-in shell (ash)
Enter 'help' for a list of built-in commands.

#

~~~~~~~~~~~~~~

After this anything I enter at the console does not matter nothing
happens :(. I am using an emulator to debug it so I am looking for any
interrupt from the serial port to the kernel when i type in some data
but I do not see any interrupt coming in.. Am I missing something
here?

Please let me know if you need more details

I am not yet subscribed to LKML so please include me in CC to any replies.


-- 
Regards,
Meher
