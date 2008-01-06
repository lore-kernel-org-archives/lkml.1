Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbYAFKDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbYAFKDW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 05:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYAFKDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 05:03:12 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2531 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbYAFKDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 05:03:11 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: 2.6.24-rc6-mm1: sparc64: undefined reference to `vmemmap_table'
Date: Sun, 6 Jan 2008 11:03:02 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
References: <20071222233056.d652743e.akpm@linux-foundation.org>
In-Reply-To: <20071222233056.d652743e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801061103.04999.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This is from allnoconfig on sparc64:

  LD      .tmp_vmlinux1
arch/sparc64/kernel/head.o: In function `kvmap_vmemmap':
(.text+0x34ec): undefined reference to `vmemmap_table'
arch/sparc64/kernel/head.o: In function `kvmap_vmemmap':
(.text+0x34f4): undefined reference to `vmemmap_table'
make: *** [.tmp_vmlinux1] Error 1

Regards,

	Mariusz

Linux sparc64 2.6.23 #2 SMP PREEMPT Fri Dec 21 21:20:01 CET 2007 sparc64 sun4u TI UltraSparc II (BlackBird) GNU/Linux
 
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.18
util-linux             2.12r
mount                  2.12r
module-init-tools      3.4
e2fsprogs              1.40.3
Linux C Library        2.6.1
Dynamic linker (ldd)   2.6.1
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
Sh-utils               6.9
udev                   115
