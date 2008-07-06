Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbYGFSTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbYGFSTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 14:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbYGFSSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 14:18:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:24626 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbYGFSSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 14:18:53 -0400
Date: Sun, 6 Jul 2008 11:17:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [Bug #10872] x86_64 boot hang when CONFIG_NUMA=n
Message-Id: <20080706111750.a6d77e81.randy.dunlap@oracle.com>
In-Reply-To: <uBi7uNfg81L.A.XLC.s0LcIB@albercik>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
	<uBi7uNfg81L.A.XLC.s0LcIB@albercik>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  6 Jul 2008 13:45:53 +0200 (CEST) Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10872
> Subject		: x86_64 boot hang when CONFIG_NUMA=n
> Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> Date		: 2008-06-05 21:50 (32 days old)
> References	: http://marc.info/?l=linux-kernel&m=121270308607116&w=4
> 		  http://lkml.org/lkml/2008/6/11/355
> 		  http://lkml.org/lkml/2008/6/15/117
> Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>


This still happens with 2.6.26-rc9.  Using CONFIG_NUMA=y boots OK.

The last lines from the (netconsole) log are:

calling  early_fill_mp_bus_info+0x0/0x7b2
node 0 link 1: io port [1000, 3fff]
node 1 link 2: io port [4000, ffff]
TOM: 0000000080000000 aka 2048M
node 0 link 1: mmio [e8000000, fddfffff]
node 1 link 2: mmio [fde00000, fdffffff]
node 0 link 1: mmio [80000000, 83ffffff]
node 1 link 2: mmio [84000000, 8fffffff]
node 0 link 1: mmio [a0000, bffff]
TOM2: 0000000280000000 aka 10240M
bus: [00,3f] on node 0 link 1
bus: 00 index 0 io port: [0, 3fff]
bus: 00 index 1 mmio: [90000000, fddfffff]
bus: 00 index 2 mmio: [80000000, 83ffffff]
bus: 00 index 3 mmio: [a0000, bffff]
bus: 00 index 4 mmio: [fe000000, ffffffff]
bus: 00 index 5 mmio: [280000000, fcffffffff]
bus: [40,ff] on node 1 link 2
bus: 40 index 0 io port: [4000, ffff]
bus: 40 index 1 mmio: [fde00000, fdffffff]


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
