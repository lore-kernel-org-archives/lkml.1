Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbZKKAWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbZKKAWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 19:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbZKKAWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 19:22:50 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:39022 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294AbZKKAWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 19:22:50 -0500
Message-Id: <1257898975.30125.1344591929@webmail.messagingengine.com>
X-Sasl-Enc: s92qWSs4qSf3+xZ+nEzHtfheneeWvOEq7FylA6G8v895 1257898975
From: myuboot@fastmail.fm
To: linux-kernel@vger.kernel.org, "linux-mips" <linux-mips@linux-mips.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
References: <1255735395.30097.1340523469@webmail.messagingengine.com>
 <4AD906D8.3020404@caviumnetworks.com>
Subject: Kernel panic - not syncing: Attempted to kill init!
In-Reply-To: <4AD906D8.3020404@caviumnetworks.com>
Date: Tue, 10 Nov 2009 18:22:55 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

I got the following error trying to bring up the /sbin/init with Kernel
2.6.31 using cramfs filesystem on a MIPS 32 board:

[    1.160000] VFS: Mounted root (cramfs filesystem) readonly on device
31:2.
[    1.171000] Freeing unused kernel memory: 116k freed
[    1.223000] Kernel panic - not syncing: Attempted to kill init!
[    1.229000] Rebooting in 3 seconds..

Using BDI I know the kernel panic happens as soon as
run_init_process("/sbin/init") in init_post() is called. The filesystem
itself seems to be ok, because I can use 'ls' command under u-boot to
see /sbin/init is a symbolic link to busybox. Also the kernel seems to
like the filesystem and can mount the filesystem.  I have for checked
for similar questions for this error, so I tried replacing /sbin/init
with a hello world program, but the result is exactly the same. It seems
neither hello-world or /sbin/init got executed. 

At this point, I don't know how to debug this issue. Any suggestion on
how to debug this issue will be greatly appreciated.

Andrew
