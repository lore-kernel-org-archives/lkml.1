Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbXKUUk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbXKUUk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 15:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbXKUUkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 15:40:47 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:41212 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755735AbXKUUkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 15:40:45 -0500
Date: Wed, 21 Nov 2007 15:40:44 -0500
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: spreading the heat?
Message-ID: <20071121204044.GB1299@csclub.uwaterloo.ca>
References: <20071121203736.GG30153@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071121203736.GG30153@vanheusden.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 09:37:36PM +0100, Folkert van Heusden wrote:
> I was wondering: if a quad core runs 2 processes at max cpu usage, won't
> that wear out the chip? As the heat is not egally spread out, some parts
> will expand more then other parts, may give damage won't it?
> So what I was suggesting maybe if that is the situation for longer time,
> maybe such processes should be scheduled to other cores as well?

If intel didn't design it to survive having a non SMP OS booted on it
using just one core 100% (say you boot DOS which doesn't have any
idle/sleep stuff in it, just actively spiing looking for input), then
the design is wrong.

I highly doubt that so I wouldn't worry about it.  After all that metal
bit on top of the cpu is called a heat spreader for a reason.  I would
be surprised if you can get more than 10 degrees C difference between
different parts of the core, although that's just a guess.

--
Len Sorensen
