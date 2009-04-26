Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZDZP6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZDZP6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 11:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZDZP6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 11:58:09 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:53910 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbZDZP6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 11:58:08 -0400
Date: Sun, 26 Apr 2009 12:57:09 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [2.6.30-rc3] powerpc: compilation error of mace module
Message-ID: <20090426155708.GA23159@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there, people.

I am attempting to compile a new kernel for my OldWorld ppc box and I'm
having some problems. The first one that appears to happen is the following:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  CC [M]  drivers/net/mace.o
drivers/net/mace.c: In function ‘mace_probe’:
drivers/net/mace.c:210: error: ‘struct net_device’ has no member named ‘open’
drivers/net/mace.c:211: error: ‘struct net_device’ has no member named ‘stop’
drivers/net/mace.c:212: error: ‘struct net_device’ has no member named ‘hard_start_xmit’
drivers/net/mace.c:213: error: ‘struct net_device’ has no member named ‘set_multicast_list’
drivers/net/mace.c:214: error: ‘struct net_device’ has no member named ‘set_mac_address’
make[3]: *** [drivers/net/mace.o] Error 1
make[2]: *** [drivers/net] Error 2
make[1]: *** [drivers] Error 2
make[1]: Leaving directory `/usr/local/media/cross-compile/linux'
make: *** [debian/stamp/build/kernel] Error 2
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Any help is appreciated.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
