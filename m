Return-Path: <linux-kernel-owner+w=401wt.eu-S1753765AbZKLSFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbZKLSFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZKLSFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:05:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43372 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbZKLSFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:05:10 -0500
Date: Thu, 12 Nov 2009 19:04:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andres Baldrich <andresbaldrich@ymail.com>, Tejun Heo <tj@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
Message-ID: <20091112180439.GC20542@elte.hu>
References: <661913.35266.qm@web113707.mail.gq1.yahoo.com>
 <alpine.LFD.2.01.0911120912160.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0911120912160.31845@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I'm really inclined to just remove the stupid thing entirely both from 
> coding-style and from checkpatch.
> 
> 80 columns do not matter. What matters is:
>  - indentation
>  - complex expressions and statements
> 
> and those two issues _together_ means that 80+ columns should be damn 
> rare, but the 80 columns itself is not at all that important.

i'd love to have that coupled with some check for too deep indentation. 
About half of the col-80 warnings i see are due to genuinely 
over-complex (and to-be-fixed) code.

Too bad that _those_ get ignored (because it's hard to fix) - while 
strings get broken up (because it's easy to 'fix') ;-)

So i'd very very much love to see some common-sense check for excessive 
indentation, and drop the col-80 warning altogether.

	Ingo
