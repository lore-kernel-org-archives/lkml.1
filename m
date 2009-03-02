Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbZCBJnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbZCBJnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 04:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZCBJnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 04:43:12 -0500
Received: from smtp.flash.net.br ([201.46.240.48]:46357 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbZCBJnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 04:43:11 -0500
Date: Mon, 2 Mar 2009 06:43:03 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.29-rc6 bombs while compiling a kernel for a
	linkstation/kurobox
Message-ID: <20090302094303.GA29819@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there.

I tried to compile a new kernel for my (powerpc) Kurobox HD (an embedded
system that has a Freescale processor), but it seems that the
compilation fails, with both my usual config file and with the shipped
linkstation_defconfig file.

I get the following error during compilation (actually a
cross-compilation):

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
arch/powerpc/platforms/built-in.o: In function `linkstation_setup_arch':
linkstation.c:(.init.text+0x218): undefined reference to `physmap_set_partitions'
drivers/built-in.o:(__ksymtab+0x9f8): undefined reference to `physmap_set_partitions'
make: *** [.tmp_vmlinux1] Error 1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

I didn't have such problems with, say, kernel 2.6.28. If anybody could
help, I would be glad to test any patches.

(Well, I already tried "blindly" adding an EXPORT_SYMBOL to
physmap_set_partitions under the mtd subtree, but it wasn't enough to
fix this issue).


Thanks in advance for any help, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
