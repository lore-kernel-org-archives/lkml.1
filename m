Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYCTUU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYCTUU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 16:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbYCTUUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 16:20:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354AbYCTUUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 16:20:09 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jon Masters <jcm@jonmasters.org>, Jon Masters <jcm@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] Markers Support for Proprierary Modules
References: <20080320002737.918213455@polymtl.ca>
	<20080320002835.384758480@polymtl.ca> <20080320191205.GA13309@elte.hu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 20 Mar 2008 16:17:33 -0400
In-Reply-To: <20080320191205.GA13309@elte.hu> (Ingo Molnar's message of "Thu, 20 Mar 2008 20:12:05 +0100")
Message-ID: <y0mzlst6tgi.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo Molnar <mingo@elte.hu> writes:

>> There seems to be good arguments for markers to support proprierary 
>> modules. So I am throwing this one-liner in and let's see how people 
>> react. [...]
>
> ugh, this is unbelievably stupid move technically - so a very strong 
> NACK. Allowing marker use in unfixable modules (today it's placing 
> markers into unfixable modules, 

As the thread suggested, this can benefit us more than it benefits
them, because it may let us see more into the blobs.


> tomorrow it's marker use by such modules) has only one clear and
> predictable effect: it turns marker calls into essential ABIs [...]

The marker_probe_*register calls are already EXPORT_SYMBOL_GPL'd, so
that covers your "tomorrow" case.  NACK that all you like when/if
someone proposes changing that.

> [if the proprietary modules attach to kernel markers ...] then all
> the pressure is on those who _can_ fix their code - meaning the
> kernel subsystem maintainers that use [you mean: define] markers.

(In a way, it would be a nice problem to have.  At this moment, there
are still no markers actually committed within -mm nor -linus.)


- FChE
