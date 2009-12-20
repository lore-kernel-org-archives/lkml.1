Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZLTMSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZLTMSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 07:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZLTMSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 07:18:50 -0500
Received: from host.vendomar.lv ([195.244.143.2]:44450 "EHLO host.vendomar.lv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbZLTMSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 07:18:49 -0500
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Dec 2009 07:18:49 EST
From: arvids <arvids@vendomar.lv>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: 2.6.32.2: undefined reference to `__udivdi3'
Date: Sun, 20 Dec 2009 14:10:42 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912201410.42851.arvids@vendomar.lv>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2.6.32.2 fails to compile:
  LD      .tmp_vmlinux1
drivers/built-in.o(.text+0x15755e): In function `menu_select':
: undefined reference to `__udivdi3'
make: *** [.tmp_vmlinux1] Error 1

$gcc -v
Reading specs from /usr/lib/gcc/i486-slackware-linux/3.4.6/specs
Configured 
with: ../gcc-3.4.6/configure --prefix=/usr --enable-shared --enable-threads=posix --enable-__cxa_atexit --disable-checking --with-gnu-ld --verbose --target=i486-slackware-linux --host=i486-slackware-linux
Thread model: posix
gcc version 3.4.6
(Slackware 11.0.0)

2.6.31.x compiled fine with this system.

Regards, Arvids
