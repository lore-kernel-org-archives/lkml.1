Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZBKILP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZBKILP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 03:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZBKIK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 03:10:59 -0500
Received: from mail-bw0-f167.google.com ([209.85.218.167]:39952 "EHLO
	mail-bw0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZBKIK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 03:10:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=vPtjky4xwCs2LAbLJxUSkrOk1xt8G2KJ1Xk8xImt+jWVLSXGGl+kVV/PNmj79nsIHm
         r82tT7SJjfhIPVozWutMR86dT15MWJooJX1L/PATkBG3HBNAXnopg0HkYCxmxosE8CKY
         C3Es4I3dLyW8kVlW7waZsajn6G0n6m5I5hRSY=
MIME-Version: 1.0
Date: Wed, 11 Feb 2009 09:10:54 +0100
Message-ID: <76392ee90902110010m1818e56esa2da4e4e88e762d1@mail.gmail.com>
Subject: [2.6.28.1] INFO: task cron:4841 blocked for more than 120 seconds
From: Folkert van Heusden <folkert.van.heusden@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since 2.6.26 my system (quadcore intel core 2 system) and definately
also with 2.6.28.1 crashes after a few days of uptime. Well, crashes:
it becomes unresponsive (can't log in with ssh and creating new imap
sessions etc also fails) but still forwards network traffic.
The netconsole gets filled with these messages:

[42265.700129] INFO: task cron:4841 blocked for more than 120 seconds.
[42265.700139] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[42265.700142] cron          D ffff88002802e700     0  4841   5367
[42265.700148]  ffff880065101dd8 0000000000000082 ffff880065101e8c
0000000000000292
[42265.700159]  ffff88009a990ab0 ffffffff80550340 ffff88009a990d28
0000000000000000
[42265.700168]  0000000000000296 ffff88012bc059c0 00000000000000d0
0000000000004111
[42265.700176] Call Trace:
[42265.700184]  [<ffffffff80464cb0>] schedule_timeout+0x1e/0xad
[42265.700188]  [<ffffffff8046427f>] wait_for_common+0xc4/0x13d
[42265.700194]  [<ffffffff8023a6fc>] default_wake_function+0x0/0xe
[42265.700199]  [<ffffffff80241632>] do_fork+0x21e/0x285
[42265.700202]  [<ffffffff80210dba>] system_call_fastpath+0x16/0x1b
[42265.700206]  [<ffffffff80211247>] ptregscall_common+0x67/0xb0

[42265.700331] INFO: task cron:4845 blocked for more than 120 seconds.
[42265.700333] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[42265.700335] cron          D ffff88002802e700     0  4845   5367
[42265.700340]  ffff88008c407dd8 0000000000000082 ffff88008c407e8c
0000000000000292
[42265.700349]  ffff88009e14a100 ffffffff80550340 ffff88009e14a378
0000000000000000
[42265.700357]  ffffffff80465fb7 ffffffff802c073f 0000000800000001
ffff88009e14a100
[42265.700365] Call Trace:
[42265.700368]  [<ffffffff80465fb7>] _spin_lock+0x5/0x7
[42265.700373]  [<ffffffff802c073f>] dup_fd+0x216/0x2bf
[42265.700378]  [<ffffffff80464cb0>] schedule_timeout+0x1e/0xad
[42265.700381]  [<ffffffff8046427f>] wait_for_common+0xc4/0x13d
[42265.700384]  [<ffffffff8023a6fc>] default_wake_function+0x0/0xe
[42265.700388]  [<ffffffff80241632>] do_fork+0x21e/0x285
[42265.700391]  [<ffffffff80210dba>] system_call_fastpath+0x16/0x1b
[42265.700395]  [<ffffffff80211247>] ptregscall_common+0x67/0xb0

--
www.unixexpert.nl
