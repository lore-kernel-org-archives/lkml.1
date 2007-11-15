Return-Path: <linux-kernel-owner+w=401wt.eu-S933990AbXKOWUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933990AbXKOWUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763092AbXKOWT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:19:59 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:52532 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760196AbXKOWT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:19:59 -0500
Message-ID: <473CC604.5050804@oracle.com>
Date: Thu, 15 Nov 2007 14:19:48 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/4] sys_indirect system call
References: <200711151641.lAFGfM8R024330@devserv.devel.redhat.com>
In-Reply-To: <200711151641.lAFGfM8R024330@devserv.devel.redhat.com>
Content-Type: text/plain; charset=windows-1250
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> The following patches provide an alternative implementation of the
> sys_indirect system call which has been discussed a few times.
> This no system call allows us to extend existing system call
> interfaces with adding more system calls.

I might quarrel with some details, but I really like the general notion.

I think we can use this to pass per-syscall syslet data to the
scheduler.  Today the patches have submission syscalls which basically
wrap some data for the scheduler around the syscall ABI.  This might
save the syslet patches from needing to know about each arch's ABI.

We'll see.  I'll give it a try.

- z
