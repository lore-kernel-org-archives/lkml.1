Return-Path: <linux-kernel-owner+w=401wt.eu-S1762624AbXIVKCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762624AbXIVKCE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 06:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbXIVKBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 06:01:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:33472 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755174AbXIVKBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 06:01:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/qm1V5ej7qexYccL6KH9MqWaAZ6y7IUEMt5D6Ghh
	Os+X7NSRrCZ34Y
Subject: Re: [git] CFS-devel, group scheduler, fixes
From: Mike Galbraith <efault@gmx.de>
To: Tong Li <tong.n.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, dimm <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <Pine.LNX.4.64.0709212018480.16240@tongli.jf.intel.com>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
	 <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
	 <1190183324.9737.7.camel@Homer.simpson.net>
	 <1190188261.9185.21.camel@Homer.simpson.net>
	 <1190191368.8687.5.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
	 <1190264114.6411.4.camel@Homer.simpson.net>
	 <1190272507.27867.20.camel@Homer.simpson.net>
	 <20070920075155.GA31641@elte.hu>
	 <1190275870.9232.6.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709212018480.16240@tongli.jf.intel.com>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 12:01:48 +0200
Message-Id: <1190455308.7404.19.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 20:27 -0700, Tong Li wrote:
> Mike,
> 
> Could you try this patch to see if it solves the latency problem?

No, but it helps some when running two un-pinned busy loops, one at nice
0, and the other at nice 19.  Yesterday I hit latencies of up to 1.2
_seconds_ doing this, and logging sched_debug and /proc/`pidof
Xorg`/sched from SCHED_RR shells.

se.wait_max              :           164.242748
se.wait_max              :           121.996128
se.wait_max              :           194.464773
se.wait_max              :           517.425411
se.wait_max              :           131.453214
se.wait_max              :           122.984190
se.wait_max              :           111.729274
se.wait_max              :           119.567580
se.wait_max              :           126.980696
se.wait_max              :           177.241452
se.wait_max              :           129.604329
se.wait_max              :           119.631657

It doesn't help at all with this oddity while running same:

root@Homer: now is
the time
foooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooor aall good men to come to the aid of their country

That was a nice 0 shell window.  I'm not a great typist, but I ain't
_that_ bad :)

	-Mike

