Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbXBEJpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbXBEJpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 04:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXBEJpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 04:45:43 -0500
Received: from mail.thinknet.ro ([86.55.168.3]:40522 "EHLO mail.thinknet.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbXBEJpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 04:45:42 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Feb 2007 04:45:42 EST
Message-ID: <1131.86.55.168.2.1170690089.squirrel@mail.thinknet.ro>
Date: Mon, 5 Feb 2007 17:41:29 +0200 (EET)
Subject: 
From: logic@thinknet.ro
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning,

I am experiencing a bug i think. I am running a 2.6.19.2 kernel on a 3Ghz
Intel with HT activated, 1 gb ram, and noname motherboard. Here is the
output of the hang:
------------[ cut here ]------------

Message from syslogd@mail at Fri Feb  2 22:47:32 2007 ...
mail kernel: kernel BUG at mm/slab.c:607!

Message from syslogd@mail at Fri Feb  2 22:47:32 2007 ...
mail kernel: invalid opcode: 0000 [#1]

Message from syslogd@mail at Fri Feb  2 22:47:32 2007 ...
mail kernel: CPU:    1

Message from syslogd@mail at Fri Feb  2 22:47:32 2007 ...
mail kernel: EIP:    0060:[<c0155ebb>]    Not tainted VLI

Message from syslogd@mail at Fri Feb  2 22:47:32 2007 ...

Message from syslogd@mail at Fri Feb  2 22:47:32 2007 ...
mail kernel: eax: 1af3a451   ebx: c89ba000   ecx: 4a5ffc80   edx: c214bfe0

Message from syslogd@mail at Fri Feb  2 22:47:32 2007 ...
mail kernel: ds: 007b   es: 007b   ss: 0068

Message from syslogd@mail at Fri Feb  2 22:47:32 2007 ...
mail kernel: EIP is at free_block+0x44/0xda

Message from syslogd@mail at Fri Feb  2 22:47:32 2007 ...
mail kernel: PREEMPT SMP
mail kernel: EFLAGS: 00010046   (2.6.19.2 #1)

Message from syslogd@mail at Fri Feb  2 22:47:32 2007 ...
mail kernel: Call Trace:

Message from syslogd@mail at Fri Feb  2 22:47:32 2007 ...
mail kernel:  =======================

Message from syslogd@mail at Fri Feb  2 22:47:32 2007 ...
mail kernel: Process events/1 (pid: 9, ti=c19b6000 task=c1983a90
task.ti=c19b6000)

Message from syslogd@mail at Fri Feb  2 22:47:32 2007 ...
mail kernel: Stack: 00000000 0000001e c196d018 c196d018 0000001e c196d000
00000000 c015664d

Message from syslogd@mail at Fri Feb  2 22:47:32 2007 ...
mail kernel:        00000000 00000000 c196fc80 c19485c0 c196fc80 c19485c0
c194b140 00000213



-- 
--
Va salut,
Alexandru Gheorghita
Technical Manager
Think.Net
phone: 0788.700.842
mail: logic@thinknet.ro


