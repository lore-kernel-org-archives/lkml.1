Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbZFCTmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbZFCTmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbZFCTm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:42:26 -0400
Received: from r00tworld.com ([212.85.137.21]:33327 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbZFCTmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:42:25 -0400
From: pageexec@freemail.hu
To: "Larry H." <research@subreption.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 03 Jun 2009 21:41:35 +0200
MIME-Version: 1.0
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change ZERO_SIZE_PTR to point at unmapped space)
Reply-to: pageexec@freemail.hu
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <4A26D1EF.21895.2E070251@pageexec.freemail.hu>
In-reply-to: <alpine.LFD.2.01.0906031142390.4880@localhost.localdomain>
References: <20090530230022.GO6535@oblivion.subreption.com>, <20090603183939.GC18561@oblivion.subreption.com>, <alpine.LFD.2.01.0906031142390.4880@localhost.localdomain>
X-mailer: Pegasus Mail for Windows (4.50 PB1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 03 Jun 2009 21:41:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 Jun 2009 at 11:45, Linus Torvalds wrote:

> 
> 
> On Wed, 3 Jun 2009, Larry H. wrote:
> > > 
> > > The fact, the NULL pointer attack is neither easy nor common. It's 
> > > perfectly reasonable to say "we'll allow mmap at virtual address zero".
> > 
> > And how could you calibrate if this attack venue isn't easy to take
> > advantage of? Or not commonly abused? What empirical results led you to this
> > conclusion?
> 
> It's not a primary attack vector. You need to have already broken local 
> security to get there - you need to be able to execute code.

during last summer's flame war^W^Wdiscussion about how you guys were covering
up security fixes you brought an example of smart university students breaking
communal boxes left and right. are you now saying that it was actually a strawman
argument as you consider that situation already broken? you can't have it both
ways ;).

> That means that you've already by-passed all the main security. It's thus 
> by definition less common than attack vectors like buffer overflows that 
> give you that capability in the first place.

that only means that you've ignored multi-user boxes.

