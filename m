Return-Path: <linux-kernel-owner+w=401wt.eu-S1764774AbYCFNeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764774AbYCFNeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934329AbYCFNeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:34:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45514 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934324AbYCFNeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:34:16 -0500
Date: Thu, 6 Mar 2008 14:33:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: Linux 2.6.25-rc4
Message-ID: <20080306133347.GA23495@elte.hu>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080306090029.GA6215@elte.hu> <20080306125929.GD17940@kernel.dk> <200803061438.22205.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803061438.22205.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> The problem looks very similar to the one recently reported by Anders:
> 
> http://lkml.org/lkml/2008/2/22/239
> 
> "Trying out 2.6.25-rc2 smartd always causes my box to hang. I can 
> switch vt:s and the keyboard seems to work.
> 
> Using sysrq-e I noticed a callpath open -> ext3 -> journals -> 
> sync_buffer -> io_scheduel -> generic_unplig_device. I'd guess the 
> open stems from smartd. Removing smartd from the startup, I'm now 
> using rc2 fine..."
> 
> Initially we thought that it is an IDE regression but after some 
> testing and further investigation it seems that IDE changes just made 
> it more likely to occur (yesterday it turned out that the kernel with 
> the "guilty" IDE commit sometimes boots fine).  The issue is easily 
> reproducible.
> 
> PS We've already verified that it is not PREEMPT related or a compiler 
> bug.

smartd is not active here though - and starting/restarting it doesnt 
provoke a hang.

	Ingo
