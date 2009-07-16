Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbZGPNAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbZGPNAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 09:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbZGPNAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 09:00:43 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:37270 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536AbZGPNAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 09:00:43 -0400
Message-ID: <4A5F2423.10802@cs.unc.edu>
Date: Thu, 16 Jul 2009 08:59:15 -0400
From: "James H. Anderson" <anderson@cs.unc.edu>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Raistlin <raistlin@linux.it>
CC: Peter Zijlstra <peterz@infradead.org>, Ted Baker <baker@cs.fsu.edu>,
       Chris Friesen <cfriesen@nortel.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       "Bjoern B. Brandenburg" <bbb@email.unc.edu>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
References: <200907102350.47124.henrik@austad.us>	 <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu>	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>	 <1247505941.7500.39.camel@twins>	 <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu>	 <20090713201305.GA25386@cs.fsu.edu> <4A5BAAE7.5020906@nortel.com>	 <20090715231109.GH14993@cs.fsu.edu>  <1247731113.15471.24.camel@twins> <1247746671.5775.279.camel@Palantir>
In-Reply-To: <1247746671.5775.279.camel@Palantir>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Raistlin wrote:
> Also, I'm not sure I can find in the FMLP paper information about the
> possibility of a task to suspend itself (e.g., I/O completion) while
> holding a short lock... I assume this is not recommended, but may be
> wrong, and, in that case, I hope Prof. Anderson and Bjorn will excuse
> and correct me. :-)
>
>   
This is a really excellent point and something I probably should have 
mentioned.  We developed the FMLP strictly for real-time (only) 
workloads.  We were specifically looking at protecting memory-resident 
resources (not I/O).  The FMLP would have to be significantly extended 
to work in settings where these assumptions don't hold.

Thanks for pointing this out.

-Jim
