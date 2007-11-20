Return-Path: <linux-kernel-owner+w=401wt.eu-S1761439AbXKTSPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439AbXKTSPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbXKTSPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:15:24 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:56582 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbXKTSPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:15:23 -0500
Message-ID: <4743242D.60304@oracle.com>
Date: Tue, 20 Nov 2007 10:15:09 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCHv4 4/6] Allow setting FD_CLOEXEC flag for new sockets
References: <200711200653.lAK6rE31025888@devserv.devel.redhat.com> <474320C4.2040600@oracle.com> <47432267.4040202@redhat.com>
In-Reply-To: <47432267.4040202@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Since there is no legacy interface to worry about all members added to
> the structure can and should be neutral of the word size.

OK, perhaps add a giant comment warning about that.  History tells us
that people will get it wrong.

> We've done
> this with some syscalls already (like pread64) where we always use the
> wide form in the parameter list.  It's just more simple here since it
> does not have to split into two 32-bit registers.

*nod*

- z
