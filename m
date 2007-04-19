Return-Path: <linux-kernel-owner+w=401wt.eu-S1161464AbXDSTAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161464AbXDSTAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161510AbXDSTAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:00:14 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:27085 "EHLO
	outbound2-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161464AbXDSTAM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:00:12 -0400
X-BigFish: VP
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: unable to run busybox /sbin/int
Date: Thu, 19 Apr 2007 12:00:01 -0700
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: unable to run busybox /sbin/int
Thread-Index: AceCtO6cMPsNlEevRRSeRNO+0GVb4Q==
From: "Tom Strader" <tom.strader@xilinx.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Apr 2007 19:00:02.0123 (UTC) FILETIME=[EF24A9B0:01C782B4]
Message-Id: <20070419190009.039B1A080F8@mail28-fra.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the final output from my kernel as I try to launch busybox
(/sbin/init is linked to /bin/busybox)
As it launches the kernel looks for libraries which do not exist (not
sure why), but it appears to find /lib/libcrypt.so.1 and /lib/libc.so.6
but the system does not output after that.  I can press keys on the
keyboard and there are echoed to the screen, I can also use the control
characters C-c, C-s, C-q, and so on and I see kernel messages indication
the uart_flush_buffer(0) is being called but busybox does not appear to
start.  Here is my kernel output, any suggestions would help. Thanks.

VFS: Mounted root (jffs2 filesystem).
Freeing init memory: 64K
#do_sys_open(/dev/console)... n_tty_set_termios()
opening ttyS0...uart_open(0) called
ret 0
running /sbin/init
#do_sys_open(/etc/ld.so.cache)... do_filp_open error
ret -2
#do_sys_open(/lib/v5l/fast-mult/half/libcrypt.so.1)... do_filp_open
error
ret -2
#do_sys_open(/lib/v5l/fast-mult/libcrypt.so.1)... do_filp_open error
ret -2
#do_sys_open(/lib/v5l/half/libcrypt.so.1)... do_filp_open error
ret -2
#do_sys_open(/lib/v5l/libcrypt.so.1)... do_filp_open error
ret -2
#do_sys_open(/lib/fast-mult/half/libcrypt.so.1)... do_filp_open error
ret -2
#do_sys_open(/lib/fast-mult/libcrypt.so.1)... do_filp_open error
ret -2
#do_sys_open(/lib/half/libcrypt.so.1)... do_filp_open error
ret -2
#do_sys_open(/lib/libcrypt.so.1)... ret 3
#do_sys_open(/lib/libc.so.6)... ret 3


Thanks,
Tom Strader
Systems Engineer
Xilinx Inc. - GPD Product Planning
Tom.Strader@Xilinx.com
+1 (408)879-4464


