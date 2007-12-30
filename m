Return-Path: <linux-kernel-owner+w=401wt.eu-S1758419AbXL3WGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419AbXL3WGW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 17:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758120AbXL3WGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 17:06:16 -0500
Received: from sphinx.net.ru ([82.146.58.194]:54343 "EHLO sphinx.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758114AbXL3WGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 17:06:15 -0500
X-Greylist: delayed 1756 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Dec 2007 17:06:14 EST
From: Dmitry Dzhus <mail@sphinx.net.ru>
To: linux-kernel@vger.kernel.org
Subject: Changing high kernel keycodes
Date: Mon, 31 Dec 2007 00:32:21 +0300
Message-ID: <871w93oom2.fsf@sphinx.net.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings!

Some of the keys on my USB-HID keyboard generate scancodes which are
bound to big keycodes in `drivers/hid/hid-input.c` and
`include/linux/input.h`, like 418, 419 or 432. Is there any possibility
to change it (in runtime, without editing `input.h` and recompiling the
kernel)? Should `setkeycodes(1)` work today? I'm using 2.6.24-rc6-git4
kernel snapshot.

I've found several postings on lkml considering KDSETKEYCODE ioctl
functioning in kernel, but I'm not sure about how it is in recent
versions.

(Sorry if this is an offtopic here, point me to an appropriate
newsgroup/ml in that case.)
-- 
Happy Hacking.

http://sphinx.net.ru
む
