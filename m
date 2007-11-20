Return-Path: <linux-kernel-owner+w=401wt.eu-S1760686AbXKTSIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686AbXKTSIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbXKTSIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:08:45 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:49584 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659AbXKTSIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:08:44 -0500
Message-ID: <4743229F.2060805@oracle.com>
Date: Tue, 20 Nov 2007 10:08:31 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCHv4 0/6] sys_indirect system call
References: <200711200653.lAK6rEYP025876@devserv.devel.redhat.com> <4742A51D.5080009@cosmosbay.com> <4743071A.9050408@redhat.com>
In-Reply-To: <4743071A.9050408@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> This was mentioned in one of my mails.  I added the parameter to
> accommodate Linus's and Zack's idea to use the functionality for syslets
> as well.  Not really a multiplexer, it is meant to be a "execute
> synchronously or asynchronously" flag.  In the latter case an additional
> parameter might be needed to indicate the notification mechanism.

I'm sure the additional parameter will be needed, and it might be pretty
involved.  I think the current notion of syslets needs, at the very least:

 - a userspace stack and IP to return to after going async
 - the completion context when completed async
 - a pointer to a return code when completed without blocking

We'll see.  I'm working on it.

- z
