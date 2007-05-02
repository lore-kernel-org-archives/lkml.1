Return-Path: <linux-kernel-owner+w=401wt.eu-S2993141AbXEBNHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993141AbXEBNHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 09:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993139AbXEBNHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 09:07:46 -0400
Received: from s4.cableone.net ([24.116.0.230]:38276 "EHLO S4.cableone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993135AbXEBNHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 09:07:45 -0400
Message-ID: <6734.129.240.220.12.1178110713.squirrel@peltkore.net>
Date: Wed, 2 May 2007 14:58:33 +0200 (CEST)
Subject: Re: [patch] CFS scheduler, -v8
From: "Vegard Nossum" <vegard@peltkore.net>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: <20070501212223.GA29867@elte.hu>
In-Reply-To: <20070501212223.GA29867@elte.hu>
X-IP-stats: Incoming Last 0, First 48, in=857, out=0, spam=0
X-External-IP: 69.92.239.228
X-Abuse-Info: Send abuse complaints to abuse@cableone.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2007 11:22 pm, Ingo Molnar wrote:
> As usual, any sort of feedback, bugreport, fix and suggestion is more
than welcome,

Hi,

The sys_sched_yield_to() is not callable from userspace on i386 because it
is not part of the syscall table (arch/i386/kernel/syscall_table.S). This
causes sysenter_entry (arch/i386/kernel/entry.S) to use the wrong count
for nr_syscalls (320 instead of 321) and return with -ENOSYS.

Vegard




