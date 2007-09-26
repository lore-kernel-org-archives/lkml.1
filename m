Return-Path: <linux-kernel-owner+w=401wt.eu-S1763190AbXIZV5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763190AbXIZV5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762905AbXIZV5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:57:40 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:45803 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762871AbXIZV5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:57:39 -0400
Date: Wed, 26 Sep 2007 14:55:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: thomas@m3y3r.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: xpad_probe: undefined reference to `led_classdev_register'
Message-Id: <20070926145531.d1e0819c.randy.dunlap@oracle.com>
In-Reply-To: <1190841933.46face4d4ae55@secure.konsole-h.de>
References: <1190841933.46face4d4ae55@secure.konsole-h.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 23:25:33 +0200 thomas@m3y3r.de wrote:

> Hi.
> 
> Current linus' git tree:
> 
> x86_64-unknown-linux-gnu-ld: BFD 2.15 assertion fail
> /home/thomas/source/crosstool-0.43/build/x86_64-unknown-linux-gnu/gcc-3.4.5-glibc-2.3.6/binutils-2.15/bfd/linker.c:619
> drivers/built-in.o(.text+0x20749d): In function `xpad_probe':
> : undefined reference to `led_classdev_register'
> drivers/built-in.o(.text+0x20756c): In function `xpad_disconnect':
> : undefined reference to `led_classdev_unregister'
> make: *** [.tmp_vmlinux1] Fehler 1
> 
> any ideas?

Please send .config file.

Ix xpad driver built-in (yes, it is) and led driver is modular?
We can fix that...

---
~Randy
Phaedrus says that Quality is about caring.
