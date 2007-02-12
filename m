Return-Path: <linux-kernel-owner+w=401wt.eu-S1030200AbXBLVxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030200AbXBLVxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 16:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030201AbXBLVxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 16:53:40 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:13056 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030200AbXBLVxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 16:53:40 -0500
Date: Mon, 12 Feb 2007 13:50:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de
Subject: build errors: uevent with CONFIG_SYSFS=n
Message-Id: <20070212135021.27754603.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


in kernel/params.c:

kernel/params.c:700: error: 'module_uevent_ops' undeclared here (not in a function)

in kernel/module.c:

kernel/built-in.o: In function `module_add_driver':
(.text+0x20c5b): undefined reference to `module_subsys'
kernel/built-in.o: In function `sys_init_module':
(.text+0x2177c): undefined reference to `module_subsys'
kernel/built-in.o: In function `sys_init_module':
(.text+0x21838): undefined reference to `module_subsys'
kernel/built-in.o: In function `kernel_param_sysfs_setup':
params.c:(.init.text+0x1492): undefined reference to `module_subsys'
kernel/built-in.o: In function `param_sysfs_init':
params.c:(.init.text+0x14f8): undefined reference to `module_subsys'

Are these already fixed?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
