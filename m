Return-Path: <linux-kernel-owner+w=401wt.eu-S933093AbZGPTTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093AbZGPTTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933069AbZGPTTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:19:14 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:51239 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940AbZGPTTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:19:14 -0400
Date: Thu, 16 Jul 2009 15:18:26 -0400 (EDT)
From: "James H. Anderson" <anderson@cs.unc.edu>
To: Raj Rajkumar <raj@ece.cmu.edu>
cc: Ted Baker <baker@cs.fsu.edu>, Noah Watkins <jayhawk@soe.ucsc.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       "Linux RT <linux-rt-users@vger.kernel.org> Fabio Checconi" 
	<fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
Subject: Re: [Fwd: Re: RFC for a new Scheduling policy/class in the
 Linux-kernel]
In-Reply-To: <4A5F7254.3020809@ece.cmu.edu>
Message-ID: <alpine.LRH.2.00.0907161513050.3814@anderson.cs.unc.edu>
References: <4A5F7254.3020809@ece.cmu.edu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Raj,

On Thu, 16 Jul 2009, Raj Rajkumar wrote:

> non-preemptive critical section.    In addition, we could allow mutexes 
> to either pick basic priority inheritance (desirable for local mutexes?) 
> or the priority ceiling version (desirable for global mutexes shared 
> across processors/cores).

This discussion when I entered it was about using global scheduling
in Linux (not partitioning), so that's what I thought the focus of the
discussion was.  What's the definition of a local mutex in that case?
And how do you use ceilings under global scheduling?

Thanks.

-Jim
