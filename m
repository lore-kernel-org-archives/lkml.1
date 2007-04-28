Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbXD1OQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbXD1OQL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 10:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbXD1OQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 10:16:11 -0400
Received: from ihemail3.lucent.com ([135.245.0.37]:53669 "EHLO
	ihemail3.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbXD1OQI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 10:16:08 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6249.0
Subject: RE: The kernel keeps spwaning /bin/sh at booting time
Date: Sat, 28 Apr 2007 22:15:28 +0800
Message-ID: <2AC135F730C4A045BAE4F1C1CB83FD4B03EF6F89@exch03.qd.lucent.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: nbd hangs in 2.6.21
Thread-Index: AceJlxTrZyhre6JmSa65A6hc4y0dngAACNhAAAIVOnA=
From: "Shan, Guo Wen (Gavin)" <gshan@alcatel-lucent.com>
To: "Shan, Guo Wen (Gavin)" <gshan@qd.lucent.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Apr 2007 14:15:28.0348 (UTC) FILETIME=[AC1919C0:01C7899F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Pls ignore this question. The error cause by the fifosize of port. I haven't set the fifo size for port, which caused this problem. 

-----Original Message-----
From: Shan, Guo Wen (Gavin) 
Sent: Saturday, April 28, 2007 9:18 PM
To: linux-kernel@vger.kernel.org
Subject: The kernel keeps spwaning /bin/sh at booting time


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
