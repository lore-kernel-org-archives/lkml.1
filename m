Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbXKEMpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbXKEMpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 07:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbXKEMpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 07:45:07 -0500
Received: from mail.gmx.net ([213.165.64.20]:49095 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753771AbXKEMpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 07:45:05 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX19ZUV0FBfdZga1a93NW+rkxJmiotREhxCyOTsewoU
	Q+b+bY9qe/MOTE
Date: Mon, 5 Nov 2007 13:44:27 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: oops in enqueue_entity with 2.6.24-rc1-g54866f03
Message-ID: <20071105124427.GA8765@alice>
References: <20071102123603.GA4988@alice> <1194266231.27652.437.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1194266231.27652.437.camel@twins>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.24-rc1 (x86_64)
X-Uptime: 13:42:02 up  1:42,  7 users,  load average: 0.25, 0.26, 0.27
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Fri, 2007-11-02 at 13:36 +0100, Eric Sesterhenn wrote:
> > hi,
> > 
> > I get the following crash with 2.6.24-rc1-g54866f03, the last version I
> > tested which booted fine was 2.6.24-rc1-gb1d08ac0
> > 
> 
> How reproducable is this?

happens every boot

> If its very much reproducable, could you git bisect it, as in between
> those commits you tested nothing much has changed, that is, nothing that
> stands out to me.

i did already bisect this but landed at a commit which wasnt the cause
(also failed when i reverted it), I am currently bisecting a second time with
-rc1 as the other starting point, because I am not sure how to make git
give me revision gb1d08ac0 again to test it another time (the binary i
have here boots fine)

Thanks, Eric

