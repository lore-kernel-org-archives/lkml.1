Return-Path: <linux-kernel-owner+w=401wt.eu-S934738AbXEHIhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934738AbXEHIhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934675AbXEHIhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:37:00 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:49097 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934724AbXEHIg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:36:56 -0400
Date: Tue, 8 May 2007 10:28:29 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: David Chinner <dgc@sgi.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org
Subject: Re: sleeping function called from invalid context at block/cfq-iosched.c
 (Was: Re: 2.6.21-mm1)
In-Reply-To: <20070508061810.GI32602149@melbourne.sgi.com>
Message-ID: <Pine.LNX.4.61.0705081026160.17280@yvahk01.tjqt.qr>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
 <463E3C50.9080207@simon.arlott.org.uk> <20070506135403.a6785f7d.akpm@linux-foundation.org>
 <463FAF1C.8060500@simon.arlott.org.uk> <20070507162349.0790706f.akpm@linux-foundation.org>
 <463FB697.6060902@simon.arlott.org.uk> <20070507163335.f5f5ea6e.akpm@linux-foundation.org>
 <463FFD0A.2050708@goop.org> <20070507222409.2d597a86.akpm@linux-foundation.org>
 <46400CD0.8050309@goop.org> <20070508061810.GI32602149@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 8 2007 16:18, David Chinner wrote:
>
>On Mon, May 07, 2007 at 10:38:24PM -0700, Jeremy Fitzhardinge wrote:
>> Andrew Morton wrote:
>> > On Mon, 07 May 2007 21:31:06 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> >   
>> >> I've found that XFS+lvm+4k stacks is completely unusable with current
>> >> kernels.  I get hangs/oopes after ~10mins of work.
>> >
>> > Sounds like this is new behaviour?
>> > I wonder why.  Same compiler version?
>> 
>> I've only recently started using xfs, so I couldn't say if its new
>> behaviour.  I did notice that it took a week or so for problems to set
>> in; my theory is that as the filesystem got a bit aged, its
>> datastructures got a bit more complex, and cause the kernel code to use
>> more stack.  But that's just a guess.

FWIW, I run dm-crypt+xfs on one machine, of course with 8k since that's
suse default. No issues. dm-crypt and lvm got something in common,
don't they?


Jan
-- 
