Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbYGUJ0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbYGUJ0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbYGUJ0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:26:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49451 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbYGUJ0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:26:39 -0400
Message-ID: <48845504.20102@cn.fujitsu.com>
Date: Mon, 21 Jul 2008 17:21:08 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Alan Cox <alan@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [build error] istallion build failure
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan, commit "istallion: use tty_port"(b02f5ad6a3ff5a1ee2a7b8ec6eee338de553b060)
is guilty.

drivers/char/istallion.c: In function ‘stli_open’:
drivers/char/istallion.c:829: error: ‘struct stliport’ has no member named ‘refcount’
drivers/char/istallion.c: In function ‘stli_close’:
drivers/char/istallion.c:891: error: ‘struct stliport’ has no member named ‘refcount’
drivers/char/istallion.c:892: error: ‘struct stliport’ has no member named ‘refcount’
drivers/char/istallion.c:893: error: ‘struct stliport’ has no member named ‘refcount’
drivers/char/istallion.c:928: error: ‘struct tty_ldisc’ has no member named ‘flush_buffer’
drivers/char/istallion.c:929: error: ‘struct tty_ldisc’ has no member named ‘flush_buffer’
drivers/char/istallion.c: In function ‘stli_waitcarrier’:
drivers/char/istallion.c:1205: error: ‘struct stliport’ has no member named ‘refcount’
drivers/char/istallion.c:1234: error: ‘struct stliport’ has no member named ‘refcount’
drivers/char/istallion.c: In function ‘stli_ioctl’:
drivers/char/istallion.c:1663: warning: unused variable ‘ival’
drivers/char/istallion.c: In function ‘stli_hangup’:
drivers/char/istallion.c:1860: error: ‘struct stliport’ has no member named ‘refcount’
drivers/char/istallion.c: In function ‘stli_portcmdstats’:
drivers/char/istallion.c:4249: error: ‘struct tty_port’ has no member named ‘flag’
drivers/char/istallion.c: At top level:
drivers/char/istallion.c:4500: warning: initialization from incompatible pointer type
make[2]: *** [drivers/char/istallion.o] Error 1
make[1]: *** [drivers/char] Error 2
make: *** [drivers] Error 2


