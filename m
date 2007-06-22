Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbXFVMz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbXFVMz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbXFVMzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:55:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:55324 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752991AbXFVMzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:55:13 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX19gGtZVT+JgZrCf0oZpIEj6iLMsqQJM8RQ6T0eb1b
	qYrxpLPVM5fiiF
Message-ID: <467BC6AF.4030603@gmx.de>
Date: Fri, 22 Jun 2007 14:55:11 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG: at fs/inotify.c:172 set_dentry_child_flags()
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there ...

I upgraded from 2.6.19-ck2 to 2.6.21.5-cfs-v17 three days ago.

Since than I have the following in my /var/log/message, up to
30 times a day:

Jun 22 13:37:18 silver BUG: at fs/inotify.c:172 set_dentry_child_flags()
Jun 22 13:37:18 silver [<c0184b6d>] set_dentry_child_flags+0xc5/0x174
Jun 22 13:37:18 silver [<c0184ccc>] remove_watch_no_event+0x6f/0x71
Jun 22 13:37:18 silver [<c0185255>] inotify_destroy+0x5d/0xa9
Jun 22 13:37:18 silver [<c0185af5>] inotify_release+0x14/0x5c
Jun 22 13:37:18 silver [<c015fd76>] __fput+0x16a/0x17b
Jun 22 13:37:18 silver [<c015e5c6>] filp_close+0x43/0x6d
Jun 22 13:37:18 silver [<c011fe4e>] close_files+0x71/0x80
Jun 22 13:37:18 silver [<c011feba>] put_files_struct+0x27/0x56
Jun 22 13:37:18 silver [<c0120850>] do_exit+0x12a/0x40a
Jun 22 13:37:18 silver [<c015f038>] sys_read+0x47/0x76
Jun 22 13:37:18 silver [<c0120b74>] do_group_exit+0x24/0x75
Jun 22 13:37:18 silver [<c0103f08>] syscall_call+0x7/0xb
Jun 22 13:37:18 silver [<c03f0000>] svcauth_gss_release+0x33d/0x371
Jun 22 13:37:18 silver =======================

Please CC me as I'm not subscribed to the list.

Thomas

-- 
keep mailinglists in english, feel free to send PM in german
