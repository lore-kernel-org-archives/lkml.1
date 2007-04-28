Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbXD1NSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbXD1NSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXD1NST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:18:19 -0400
Received: from hoemail1.lucent.com ([192.11.226.161]:64490 "EHLO
	hoemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034AbXD1NSS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:18:18 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6249.0
Subject: The kernel keeps spwaning /bin/sh at booting time
Date: Sat, 28 Apr 2007 21:17:38 +0800
Message-ID: <2AC135F730C4A045BAE4F1C1CB83FD4B03EF6F7F@exch03.qd.lucent.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: nbd hangs in 2.6.21
Thread-Index: AceJlxTrZyhre6JmSa65A6hc4y0dngAACNhA
From: "Shan, Guo Wen (Gavin)" <gshan@alcatel-lucent.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Apr 2007 13:17:38.0332 (UTC) FILETIME=[97CEADC0:01C78997]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The system keeps spwaning /bin/sh at booting time. I'm using busybox1.5. Do you have any ideas?

v_console_console_init: try to register CONSOLE driver
register_console: name ttyVC, index 1, a0=0xc02e910c, a1=0xc000380c,a2=0xc0006378
register_console: console ttyVC, cmd line ttyMM
register_console: console ttyVC1 IS the one !!!!!!
**************************************************************
name: ttyVC, index: 1, flags: 0x00000017
name: ttyMM, index: 0, flags: 0x00000005
**************************************************************
v_console_console_init: register CONSOLE driver sucessfully
Freeing unused kernel memory: 1536k init
Warning: unable to open an initial console.

Please press Enter to activate this console. init: can't log to /dev/tty5
starting pid 191, tty '/dev/ttyS1': '/bin/sh'
                                             # 
                                               Please press Enter to activate this console. init: can't log to /dev/tty5
starting pid 192, tty '/dev/ttyS1': '/bin/sh'
                                             # 
                                               Please press Enter to activate this console. init: can't log to /dev/tty5
starting pid 193, tty '/dev/ttyS1': '/bin/sh'
                                             # 
                                               Please press Enter to activate this console. init: can't log to /dev/tty5
starting pid 194, tty '/dev/ttyS1': '/bin/sh'
                                             # 
                                               Please press Enter to activate this console. init: can't log to /dev/tty5
starting pid 195, tty '/dev/ttyS1': '/bin/sh'
                                             # 
                                               Please press Enter to activate this console. init: can't log to /dev/tty5
starting pid 196, tty '/dev/ttyS1': '/bin/sh'
                                             # 
                                               Please press Enter to activate this console. init: can't log to /dev/tty5
starting pid 197, tty '/dev/ttyS1': '/bin/sh'
                                             # 
                                               Please press Enter to activate this console. init: can't log to /dev/tty5
starting pid 198, tty '/dev/ttyS1': '/bin/sh'
                                             # 
                                               Please press Enter to activate this console. init: can't log to /dev/tty5
starting pid 199, tty '/dev/ttyS1': '/bin/sh'

Thanks,
Gavin
