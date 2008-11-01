Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbYKACvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbYKACvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 22:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYKACuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 22:50:55 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:49880 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbYKACuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 22:50:54 -0400
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200811010250.mA12orqv005451@clem.clem-digital.net>
Subject: 2.6.28-rc2-git6 fails compile -- cpu/common.c
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Fri, 31 Oct 2008 22:50:53 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fyi
2.6.28-rc2-git fails compile, uniprocessor x86. (Missed git4 and git5.)

  CC      arch/x86/kernel/cpu/common.o
arch/x86/kernel/cpu/common.c: In function 'cpu_init':
arch/x86/kernel/cpu/common.c:1141: error: 'boot_cpu_id' undeclared (first use in this function)
arch/x86/kernel/cpu/common.c:1141: error: (Each undeclared identifier is reported only once
arch/x86/kernel/cpu/common.c:1141: error: for each function it appears in.)
make[2]: *** [arch/x86/kernel/cpu/common.o] Error 1
make[1]: *** [arch/x86/kernel/cpu] Error 2
make: *** [arch/x86/kernel] Error 2

-- 
Pete Clements 
