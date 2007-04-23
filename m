Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbXDWHDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbXDWHDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 03:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbXDWHDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 03:03:30 -0400
Received: from mail14.syd.optusnet.com.au ([211.29.132.195]:49837 "EHLO
	mail14.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225AbXDWHD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 03:03:29 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [ck] Re: [ANNOUNCE] Staircase Deadline cpu scheduler version 0.45
Date: Mon, 23 Apr 2007 17:02:40 +1000
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, Michael Gerdau <mgd@technosis.de>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Al Boldi <a1426z@gawab.com>, Bill Huey <billh@gnuppy.monkey.org>,
       Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Matt Mackall <mpm@selenic.com>
References: <200704221441.48897.kernel@kolivas.org> <20070422142216.GA17210@1wt.eu> <200704230035.54002.kernel@kolivas.org>
In-Reply-To: <200704230035.54002.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704231702.40730.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007 00:35, Con Kolivas wrote:
> On Monday 23 April 2007 00:22, Willy Tarreau wrote:
> > X is still somewhat jerky, even
> > at nice -19. I'm sure it happens when it's waiting in the other array. We
> > should definitely manage to get rid of this if we want to ensure low
> > latency.
>
> Yeah that would be correct. It's clearly possible to keep the whole design
> philosophy and priority system intact with SD and do away with the arrays
> if it becomes a continuous stream instead of two arrays but that requires
> some architectural changes. I've been concentrating on nailing all the
> remaining issues (and they kept cropping up as you've seen *blush*).
> However... I haven't quite figured out how to do that architectural change
> just yet either so let's just iron out all the bugs out of this now.

By the way, Ingo et al, this is yet again an open invitation to suggest ideas, 
or better yet, provide code to do this with now that the core of SD is 
finally looking to be doing everything as expected within its constraints. 
I'm low on cycles and would appreciate the help. I'd prefer to leave 
everything that's queued in -mm as is for the moment before someone wants to 
take this into another wild direction.

Thanks!

-- 
-ck
