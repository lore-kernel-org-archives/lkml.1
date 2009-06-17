Return-Path: <linux-kernel-owner+w=401wt.eu-S1764446AbZFQD27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764446AbZFQD27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 23:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZFQD2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 23:28:50 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:61973 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753438AbZFQD2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 23:28:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlEGANf4N0pMROLw/2dsb2JhbACBUNE1hAsF
Date: Tue, 16 Jun 2009 23:16:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.30 BUG] CPU hotplug and alternatives problem when going 2 ->
	1 CPU
Message-ID: <20090617031624.GA30905@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:11:43 up 108 days, 23:37,  4 users,  load average: 0.34, 0.26,
	0.41
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I ran into a "stucked process" when trying to bring down all my CPUs on
a 2.6.30 kernel (+ lttng patchset). It's Intel Core2 Xeon.

My printk output showed :

[  133.866683] CPU 1 is now offline                                   
[  134.958702] CPU 2 is now offline                                             
[  136.054832] CPU 3 is now offline                                             
[  137.148867] CPU 4 is now offline                                             
[  138.252997] CPU 5 is now offline                                             
[  139.455014] CPU 6 is now offline                                             
[  140.561271] CPU 7 is now offline                                             
[  140.570979] SMP alternatives: switching to UP code                           

Booting with noreplace-smp makes everything work fine. Maybe it's a new
bug in 2.6.30 ?

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
