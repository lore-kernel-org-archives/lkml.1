Return-Path: <linux-kernel-owner+w=401wt.eu-S1766925AbXDSSQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766925AbXDSSQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 14:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766927AbXDSSQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 14:16:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:43377 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766925AbXDSSQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 14:16:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Sc7XlWisAs/ORjQe7P8cWkcuWg9esu9Je7HWN7XM7X4c//QzQSrm3fZD6IPSFlxshBemPtc2zNql5zBQs02gZ4en+pNRQ73MuOW3eGcFuqtiol+WSzeYeN5goVQ4tYvcUbfDJL3pNjM0cNAFNIdx353wr5h/zkgIdF/6fplSXbc=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: Renice X for cpu schedulers
Date: Thu, 19 Apr 2007 14:16:13 -0400
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070417062621.GL2986@holomorphy.com> <20070419063810.GA22418@elte.hu> <200704192159.35546.kernel@kolivas.org>
In-Reply-To: <200704192159.35546.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704191416.14374.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 April 2007, Con Kolivas wrote:

[and I snipped a good overview]

>So yes go ahead and think up great ideas for other ways of metering out cpu
>bandwidth for different purposes, but for X, given the absurd simplicity of
>renicing, why keep fighting it? Again I reiterate that most users of SD have
>not found the need to renice X anyway except if they stick to old habits of
>make -j4 on uniprocessor and the like, and I expect that those on CFS and
>Nicksched would also have similar experiences.

FWIW folks, I have never touched x's niceness, its running at the default -1 
for all of my so-called 'tests', and I have another set to be rebooted to 
right now.  And yes, my kernel makeit script uses -j4 by default, and has 
used -j8 just for effects, which weren't all that different from what I 
expected in 'abusing' a UP system that way.  The system DID remain usable, 
not snappy, but usable.

Having tried re-nicing X a while back, and having the rest of the system 
suffer in quite obvious ways for even 1 + or - from its default felt pretty 
bad from this users perspective.

It is my considered opinion (yeah I know, I'm just a leaf in the hurricane of 
this list) that if X has to be re-niced from the 1 point advantage its had 
for ages, then something is basicly wrong with the overall scheduling, cpu or 
i/o, or both in combination.  FWIW I'm using cfq for i/o.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Moore's Constant:
	Everybody sets out to do something, and everybody
	does something, but no one does what he sets out to do.
