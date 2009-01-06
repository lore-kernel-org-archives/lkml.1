Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbZAFOjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbZAFOjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 09:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZAFOjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 09:39:31 -0500
Received: from sh.osrg.net ([192.16.179.4]:40512 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbZAFOja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 09:39:30 -0500
Date: Tue, 6 Jan 2009 23:37:47 +0900
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, travis@sgi.com
Subject: tip: IA64 build error
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090106233758L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got the followings with tip/master:

drivers/pci/probe.c: In function 'pci_bus_show_cpuaffinity':
drivers/pci/probe.c:56: error: implicit declaration of function 'cpumask_from_node'
drivers/pci/probe.c:56: warning: pointer/integer type mismatch in conditional expression
make[3]: *** [drivers/pci/probe.o] Error 1
make[2]: *** [drivers/pci] Error 2


it's due to the typo in arch/ia64/include/asm/topology.h, I guess.
