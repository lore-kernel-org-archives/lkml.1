Return-Path: <linux-kernel-owner+w=401wt.eu-S1751953AbYJUIi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbYJUIi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 04:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbYJUIin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 04:38:43 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51656 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbYJUIim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 04:38:42 -0400
Message-Id: <200810210838.m9L8cegu033608@www262.sakura.ne.jp>
Subject: [2.6.27.2] Unnamed entry appears in /sys/module/usbcore/parameters/ .
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Oct 2008 17:38:40 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There appears an entry which has no name.
-----
# cat /proc/version
Linux version 2.6.27.2 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #1 SMP Tue Oct 21 17:27:55 JST 2008
# ls -ail /sys/module/usbcore/parameters/
total 0
236 drwxr-xr-x  2 root root    0 Oct 21 17:31
236 drwxr-xr-x  2 root root    0 Oct 21 17:31 .
235 drwxr-xr-x  4 root root    0 Oct 21 17:31 ..
237 -rw-r--r--  1 root root 4096 Oct 21 17:31 autosuspend
239 -r--r--r--  1 root root 4096 Oct 21 17:31 blinkenlights
240 -rw-r--r--  1 root root 4096 Oct 21 17:31 old_scheme_first
241 -rw-r--r--  1 root root 4096 Oct 21 17:31 use_both_schemes
# ls -aild /sys/module/usbcore/parameters/
236 drwxr-xr-x  2 root root 0 Oct 21 17:31 /sys/module/usbcore/parameters/
#
-----
No such behavior for kernel 2.6.26.6 .
Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.27.2 .

Regards.
