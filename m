Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbXEPPUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbXEPPUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbXEPPUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:20:44 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:5295 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755936AbXEPPUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:20:43 -0400
Message-ID: <464B2155.8040005@cfl.rr.com>
Date: Wed, 16 May 2007 11:20:53 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Dong Feng <middle.fengdong@gmail.com>
CC: pradeep singh <2500.pradeep@gmail.com>,
       Bahadir Balban <bahadir.balban@gmail.com>,
       Learning Linux <learninglinux4@gmail.com>, kernelnewbies@nl.linux.org,
       linux-newbie@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Why can't we sleep in an ISR?
References: <9f1dc2cf0705132337k13aa3ccesc575d4550492a24e@mail.gmail.com>  <366312910705140010m78b215a2t1753445e81120288@mail.gmail.com>  <9f1dc2cf0705140016w6d8f44f9wec7586e7879af873@mail.gmail.com>  <7ac1e90c0705140824i54e1c43ela3ab3d89827c0339@mail.gmail.com>  <a <a2ebde260705151549r2762ac1fk9a68db7b903e6525@mail.gmail.com>
In-Reply-To: <a2ebde260705151549r2762ac1fk9a68db7b903e6525@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 May 2007 15:20:52.0542 (UTC) FILETIME=[CA8915E0:01C797CD]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15178.003
X-TM-AS-Result: No--0.931200-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dong Feng wrote:
> If what you say were true, then an ISR would be running in the same
> context as the interrupted process. 

Yes, and it is, as others have said in this thread, which is a good 
reason why ISRs can't sleep.

> But please check any article or
> book, it will say ISR running in different context from any process.
> So ISR is considered in its own context, although it shares a lot of
> things with the interrupted process. I would only say *context* is a
> higher-level logical concept.

Depends on which book or article you are reading I suppose.  The 
generally accepted and often used thought is that ISRs technically are 
running in the context of the interrupted process, but because that 
context is unknown and therefore should not be used, it is often said 
that they run in no context, or outside of any context.  Sometimes 
people then assume that because they run outside of any ( particular ) 
process context, they must be in their own context, but this is a mistake.


