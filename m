Return-Path: <linux-kernel-owner+w=401wt.eu-S1765039AbYBZUsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765039AbYBZUsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYBZUsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:48:09 -0500
Received: from 1wt.eu ([62.212.114.60]:2154 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbYBZUsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:48:07 -0500
Date: Tue, 26 Feb 2008 21:47:07 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] Disk shock protection (revisited)
Message-ID: <20080226204707.GB8953@1wt.eu>
References: <87skzgd1zk.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87skzgd1zk.fsf@denkblock.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Elias,

On Tue, Feb 26, 2008 at 12:56:31AM +0100, Elias Oltmanns wrote:

[ very interesting project ]

> Probably, the major problem is that I don't really know what kind of
> applications (apart from shock protection) I should be thinking of that
> might want to have a queue freezing facility at hand.

In terms of applications, depending on the sensitivity of the accelerometer,
we can imagine that a laptop would immediately force unmount crypted
filesystems if it believes it's being stolen, for instance. It's just a
random idea that comes to my mind, in the hope it may help you imagine
some crazy usages. But generally you should not fool your mind with too
many hypothetical cases, ideas will come once you provide a smart interface
and this interface will evolve with future needs.

Concerning your daemon, I think that every millisecond counts when a
laptop falls on the floor. So I think that running it in the kernel
should help you gain those precious milliseconds. I doubt your daemon
could trigger fast enough while X is starting or during some activities
which require a lot of CPU or uninterruptible I/O. If (I don't know)
the driver can be woken up by an interrupt from the controller, it
might react faster.

Good luck, and I sincerely wish you success on this project!
Willy

