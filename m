Return-Path: <linux-kernel-owner+w=401wt.eu-S1763148AbXIXTYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763148AbXIXTYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758796AbXIXTYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:24:21 -0400
Received: from zaphod.dth.net ([85.159.112.68]:57565 "EHLO zaphod.dth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044AbXIXTYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:24:20 -0400
Date: Mon, 24 Sep 2007 21:24:10 +0200
From: Danny ter Haar <dth@dth.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Q: new kernel not booting (init segfaults) : how to debug ?
Message-ID: <20070924192410.GA8881@dth.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

System: firewall
-Epia 5000 via c3 system 
-bios 2.07 (latest available, upgraded from 1.09 with same behaviour)
-128Mb flash memory (ide emulation)
-256mb ram
-voyage linux (debian based)
Runs "standard" kernel just fine, 2.6.22.17 also compiles/runs
where as 2.6.23-rcX wont

Typed over from screenshot:

---------------------------------------
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 148k freed
init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
printk: 788820 messages suppressed.
---------------------------------------

The only thing changed is the kernel.
I'm just plain flabbergasted about why this occurs and complete
lost how to debug/persue this any further.

Kernel config/systemmap etc at http://www.dth.net/kernel/c3/

Danny
