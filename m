Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbZGDQkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbZGDQkl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 12:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbZGDQke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 12:40:34 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:38720 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZGDQkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 12:40:33 -0400
Date: Sat, 4 Jul 2009 12:38:26 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: value of returning positive error code from module_init()?
Message-ID: <alpine.LFD.2.00.0907041236440.3907@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  whoops, i forgot to ask this as well.  accidentally, i returned a
positive value from a module_init() routine, which loaded the module
and generated in /var/log/messages:

...
Jul  4 12:34:43 localhost kernel: hi module being loaded.
Jul  4 12:34:43 localhost kernel: sys_init_module: 'hi'->init
suspiciously returned 42, it should follow 0/-E convention
Jul  4 12:34:43 localhost kernel: sys_init_module: loading module
anyway...
Jul  4 12:34:43 localhost kernel: Pid: 3881, comm: insmod Tainted: G
M       2.6.29.5-191.fc11.x86_64 #1
Jul  4 12:34:43 localhost kernel: Call Trace:
Jul  4 12:34:43 localhost kernel: [<ffffffff8106f33b>]
sys_init_module+0x13e/0x1cd
Jul  4 12:34:43 localhost kernel: [<ffffffff8101133a>]
system_call_fastpath+0x16
...

  i'd never seen that before, i guess because i never returned a
positive error code.  is there a tradition for returning positive
values?  for what purpose?  thanks.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
