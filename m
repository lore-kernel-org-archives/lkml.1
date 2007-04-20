Return-Path: <linux-kernel-owner+w=401wt.eu-S1767290AbXDTWUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767290AbXDTWUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 18:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767293AbXDTWUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 18:20:09 -0400
Received: from smtp.ono.com ([62.42.230.12]:59113 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767290AbXDTWUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 18:20:04 -0400
Date: Sat, 21 Apr 2007 00:19:55 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: /proc/sef/fd/0 is a socket ?!
Message-ID: <20070421001955.3dbd2b99@werewolf-wl>
X-Mailer: Claws Mail 2.9.1cvs2 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

After a big update in my systems, two of them just does not let me ssh into it.
It says that stdin is not a terminal. The same hapens if I try to open any
terminal emulator, like aterm.

It finally let me do somathing like ssh xxx@xxx /bin/bash -i, to get a terminal,
and I saw this:

nada:/etc/rc.d# ll /proc/self/fd/
total 0
lrwx------ 1 root root 64 2007.04.21 00:13 0 -> socket:[23705]
lrwx------ 1 root root 64 2007.04.21 00:13 1 -> socket:[23705]
lrwx------ 1 root root 64 2007.04.21 00:13 2 -> socket:[23707]
lr-x------ 1 root root 64 2007.04.21 00:13 3 -> /proc/6814/fd/

whats that ? udev really messed something ?

One other box is working just fine.
Any ideas ?

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.0 (Cooker) for i586
Linux 2.6.20-jam10 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #1 SMP PREEMPT
