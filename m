Return-Path: <linux-kernel-owner+w=401wt.eu-S1763410AbXIZVZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763410AbXIZVZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760914AbXIZVZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:25:35 -0400
Received: from konsoleh1.your-server.de ([213.133.104.191]:55104 "EHLO
	konsoleh1.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761355AbXIZVZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:25:35 -0400
Message-ID: <1190841933.46face4d4ae55@secure.konsole-h.de>
Date: Wed, 26 Sep 2007 23:25:33 +0200
From: thomas@m3y3r.de
To: linux-kernel@vger.kernel.org
Subject: xpad_probe: undefined reference to `led_classdev_register'
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Current linus' git tree:

x86_64-unknown-linux-gnu-ld: BFD 2.15 assertion fail
/home/thomas/source/crosstool-0.43/build/x86_64-unknown-linux-gnu/gcc-3.4.5-glibc-2.3.6/binutils-2.15/bfd/linker.c:619
drivers/built-in.o(.text+0x20749d): In function `xpad_probe':
: undefined reference to `led_classdev_register'
drivers/built-in.o(.text+0x20756c): In function `xpad_disconnect':
: undefined reference to `led_classdev_unregister'
make: *** [.tmp_vmlinux1] Fehler 1

any ideas?

mfg
thomas

