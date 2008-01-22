Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYAVUal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYAVUal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYAVUaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:30:30 -0500
Received: from orion.ambsoft.pl ([212.109.144.130]:38357 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbYAVUa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:30:29 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc8-mm1: sparc64 warning at fs/file_table.c:49 __fput+0x1a8/0x1e0()
Date: Tue, 22 Jan 2008 21:30:23 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       sparclinux@vger.kernel.org
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801222130.24136.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Issuing "sysrq-s sysrq-u" sequence causes these warnings on sparc64:

------------[ cut here ]------------
WARNING: at fs/file_table.c:49 __fput+0x1a8/0x1e0()
Modules linked in: sg sr_mod cdrom
Call Trace:
 [00000000004c9ac8] __fput+0x1b0/0x1e0
 [00000000004c6978] filp_close+0x60/0x80
 [00000000004c6a18] sys_close+0x80/0xe0
 [00000000004062d4] linux_sparc_syscall32+0x3c/0x40
 [0000000000012f1c] 0x12f24
---[ end trace 6dbe14ff8ec57744 ]---
------------[ cut here ]------------
WARNING: at fs/file_table.c:49 __fput+0x1a8/0x1e0()
Modules linked in: sg sr_mod cdrom
Call Trace:
 [00000000004c9ac8] __fput+0x1b0/0x1e0
 [00000000004c6978] filp_close+0x60/0x80
 [00000000004c6a18] sys_close+0x80/0xe0
 [00000000004062d4] linux_sparc_syscall32+0x3c/0x40
 [0000000000012f1c] 0x12f24
---[ end trace 6dbe14ff8ec57744 ]---
------------[ cut here ]------------
WARNING: at fs/file_table.c:49 __fput+0x1a8/0x1e0()
Modules linked in: sg sr_mod cdrom
Call Trace:
 [00000000004c9ac8] __fput+0x1b0/0x1e0
 [00000000004c6978] filp_close+0x60/0x80
 [00000000004c6a18] sys_close+0x80/0xe0
 [00000000004062d4] linux_sparc_syscall32+0x3c/0x40
 [0000000000012f1c] 0x12f24
---[ end trace 6dbe14ff8ec57744 ]---
------------[ cut here ]------------
WARNING: at fs/file_table.c:49 __fput+0x1a8/0x1e0()
Modules linked in: sg sr_mod cdrom
Call Trace:
 [00000000004c9ac8] __fput+0x1b0/0x1e0
 [00000000004c6978] filp_close+0x60/0x80
 [00000000004c6a18] sys_close+0x80/0xe0
 [00000000004062d4] linux_sparc_syscall32+0x3c/0x40
 [0000000000012f1c] 0x12f24
---[ end trace 6dbe14ff8ec57744 ]---

Regards,

	Mariusz
