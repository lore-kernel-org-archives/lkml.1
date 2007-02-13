Return-Path: <linux-kernel-owner+w=401wt.eu-S965447AbXBMBUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965447AbXBMBUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 20:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030525AbXBMBUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 20:20:18 -0500
Received: from clem.clem-digital.net ([68.16.168.10]:42314 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965447AbXBMBUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 20:20:16 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 20:20:16 EST
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200702130110.l1D1ADai012897@clem.clem-digital.net>
Subject: 2.6.20-git8 fails compile -- net/built-in.o __ipv6_addr_type
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Mon, 12 Feb 2007 20:10:13 -0500 (EST)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.20-git8 fails compile:

  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
net/built-in.o: In function `svc_udp_recvfrom':
svcsock.c:(.text+0x61be4): undefined reference to `__ipv6_addr_type'
make: *** [.tmp_vmlinux1] Error 1

-- 
Pete Clements 
