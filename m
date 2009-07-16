Return-Path: <linux-kernel-owner+w=401wt.eu-S933168AbZGPTsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbZGPTsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933112AbZGPTsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:48:15 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:38297 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933103AbZGPTsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:48:14 -0400
Date: Thu, 16 Jul 2009 15:46:39 -0400 (EDT)
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
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Karthik Singaram Lakshmanan <lakshmanan@cmu.edu>,
       Dionisio de Niz <dionisio@sei.cmu.edu>
Subject: Re: [Fwd: Re: RFC for a new Scheduling policy/class in the
 Linux-kernel]
In-Reply-To: <4A5F806D.6040701@ece.cmu.edu>
Message-ID: <alpine.LRH.2.00.0907161538340.3814@anderson.cs.unc.edu>
References: <4A5F7254.3020809@ece.cmu.edu> <alpine.LRH.2.00.0907161513050.3814@anderson.cs.unc.edu> <4A5F806D.6040701@ece.cmu.edu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It looks to me like Jim and Bjoern name the kernel-mutex locking scheme 
> (of non-preemption and FIFO queueing) as FMLP and advocate it for 
> user-level mutexes.  Jim: Please correct me if my interpretation is 
> incorrect.

I should have addressed this, sorry.

Actually, I don't advocate for anything.  :-)  As I said in my very
first email in this thread, in the LTIMUS^RT project, changing Linux
is not one of our goals.  I leave that to other people who are way
smarter than me.

But to the point you raise, please note that the long version of the
FMLP is a little more than combining non-preemption with FIFO waiting
since waiting is via suspension.  And as I said in an earlier email,
we designed it for a real-time (only) environment.  However, I think
a user-level variant that could be used in a more general environment
would certainly be possible.

-Jim

P.S. We didn't talk about the low processor utlization (Dhall effect)
mentioned in your last email.  However, that applies to hard real-time
workloads, not soft real-time workloads.  This discussion has been
touching on both.

