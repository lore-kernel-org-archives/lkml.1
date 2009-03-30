Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbZC3R4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbZC3R4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZC3R4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:56:22 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56840 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbZC3R4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:56:22 -0400
Message-ID: <49D10797.9080306@garzik.org>
Date: Mon, 30 Mar 2009 13:55:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       =?ISO-8859-1?Q?Fernan?= =?ISO-8859-1?Q?do_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 5/7] vfs: Add  wbcflush sysfs knob to disable storage
 device writeback cache flushes
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49D0B535.2010106@oss.ntt.co.jp> <49D0B978.5030107@oss.ntt.co.jp> <200903301714.13174.bzolnier@gmail.com> <20090330175121.GW5178@kernel.dk>
In-Reply-To: <20090330175121.GW5178@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Mon, Mar 30 2009, Bartlomiej Zolnierkiewicz wrote:
>> On Monday 30 March 2009, Fernando Luis Vázquez Cao wrote:
>>> Add a sysfs knob to disable storage device writeback cache flushes.
>> The horde of casual desktop users (with me included) would probably prefer
>> having two settings -- one for filesystem barriers and one for fsync().
>>
>> IOW I prefer higher performance at the cost of risking losing few last
>> seconds/minutes of work in case of crash / powerfailure but I would still
>> like to have the filesystem in the consistent state after such accident.
> 
> The knob is meant to control whether we really need to send a flush to
> the device or not, so it's an orthogonal issue to what you are talking
> about. For battery backed caches, we never need to flush. This knob is
> useful IFF we have devices with write back caches that STILL do a cache
> flush.

How do installers and/or kernels detect a battery-backed cache that does 
not need flush?

	Jeff



