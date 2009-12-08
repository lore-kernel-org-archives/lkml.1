Return-Path: <linux-kernel-owner+w=401wt.eu-S966566AbZLHXhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966566AbZLHXhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 18:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965278AbZLHXhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 18:37:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55581
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965263AbZLHXhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 18:37:16 -0500
Date: Tue, 08 Dec 2009 15:37:22 -0800 (PST)
Message-Id: <20091208.153722.15444835.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Subject: asm/hw_breakpoint.h header check failures...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is very strange, I never saw this error reported against
-next all these past weeks yet I know they do build testing
with this check enabled :-)

/home/davem/src/GIT/sparc-2.6/usr/include/linux/perf_event.h:22: included file 'asm-sparc/hw_breakpoint.h' is not exported
make[3]: *** [/home/davem/src/GIT/sparc-2.6/usr/include/linux/.check] Error 123
make[2]: *** [linux] Error 2
make[1]: *** [headers_check] Error 2
make: *** [vmlinux] Error 2
