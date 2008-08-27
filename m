Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYH0V24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYH0V24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYH0V2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:28:46 -0400
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:41127 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbYH0V2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:28:45 -0400
X-Greylist: delayed 4243 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2008 17:28:45 EDT
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Cox <alan@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	<alpine.LFD.1.10.0808241120460.3363@nehalem.linux-foundation.org>
From: Peter Osterlund <petero2@telia.com>
Date: Wed, 27 Aug 2008 22:17:49 +0200
In-Reply-To: <alpine.LFD.1.10.0808241120460.3363@nehalem.linux-foundation.org> (Linus Torvalds's message of "Sun\, 24 Aug 2008 11\:34\:32 -0700 \(PDT\)")
Message-ID: <m3k5e2qkk2.fsf@telia.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sat, 23 Aug 2008, Rafael J. Wysocki wrote:
>> 
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11401
>> Subject		: pktcdvd: BUG, NULL pointer dereference in pkt_ioctl, bisected
>> Submitter	: Laurent Riffard <laurent.riffard@free.fr>
>> Date		: 2008-08-22 08:16 (2 days old)
>
> This one looks irritating.
>
> It's bisected to 5b6155ee70e9c4d2ad7e6f514c8eee06e2711c3a ("pktcdvd: push 
> BKL down into driver"), but the problem goes deeper than that.
...
> Grr.
...
> Double grr.
...
> Hmm?
>
> We need to fix this.

Why not just revert the offending change and try again during the next
merge window, assuming someone has figured out an acceptable way to
handle this mess by then?

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
