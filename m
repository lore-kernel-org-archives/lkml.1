Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbYCQHXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbYCQHXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 03:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYCQHX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 03:23:29 -0400
Received: from brick.kernel.dk ([87.55.233.238]:18350 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYCQHX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 03:23:28 -0400
Date: Mon, 17 Mar 2008 08:23:25 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Anders Eriksson <aeriksson@fastmail.fm>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4
Message-ID: <20080317072324.GX17940@kernel.dk>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org> <200803161907.04581.bzolnier@gmail.com> <200803161926.36169.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803161926.36169.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16 2008, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 16 March 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> [...]
> 
> > I think that we are looking into completely wrong direction...
> 
> Alt-SysRq-T traces that Anders posted shows that the system hangs inside
> block layer, if not clearing DRQ would be the case we should see system
> getting stuck inside IDE (or at least IDE commands timing out)...

The bisect ends up pointing at IDE bits everytime, plus it's io
scheduler independent. So I don't think a generic issue is very likely.

> I really do think that it is the same hang-in-block-layer issue that
> Ingo managed to hit once (his system was using libata)...

There's no data to back any such conclusion up, that would be extremely
hand wavy (at best).

Ingo hit a hang in one boot out of hundreds to thousands. Anders can
reproduce easily, should be easy enough to narrow down.

-- 
Jens Axboe

