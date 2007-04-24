Return-Path: <linux-kernel-owner+w=401wt.eu-S1161780AbXDXOii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161780AbXDXOii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 10:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161783AbXDXOii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 10:38:38 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:62144 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161780AbXDXOih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 10:38:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hBAAw5ldPFbI1eTPeBPh5iMJ0rgK6PeaA3tcq1MK1vU+LzAfhvMNMRMtySPqmbEe+jMCP20yBjzkk7WIFp6zFmf4Lj2wBx1tKrCEnU6t+LpHdtNPZ7ffcFW4BCGwfIu/YyMyqYaFDTuEeNnCNlzTP5O5ev0IvsvAz3lYBn6tA8c=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Tue, 24 Apr 2007 10:38:32 -0400
User-Agent: KMail/1.9.6
Cc: David Lang <david.lang@digitalinsight.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       caglar@pardus.org.tr
References: <200704220959.34978.kernel@kolivas.org> <Pine.LNX.4.63.0704232342440.7121@qynat.qvtvafvgr.pbz> <20070424072408.GA27769@elte.hu>
In-Reply-To: <20070424072408.GA27769@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704241038.32766.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007, Ingo Molnar wrote:
>* David Lang <david.lang@digitalinsight.com> wrote:
>> > (Btw., to protect against such mishaps in the future i have changed
>> > the SysRq-N [SysRq-Nice] implementation in my tree to not only
>> > change real-time tasks to SCHED_OTHER, but to also renice negative
>> > nice levels back to 0 - this will show up in -v6. That way you'd
>> > only have had to hit SysRq-N to get the system out of the wedge.)
>>
>> if you are trying to unwedge a system it may be a good idea to renice
>> all tasks to 0, it could be that a task at +19 is holding a lock that
>> something else is waiting for.
>
>Yeah, that's possible too, but +19 tasks are getting a small but
>guaranteed share of the CPU so eventually it ought to release it. It's
>still a possibility, but i think i'll wait for a specific incident to
>happen first, and then react to that incident :-)
>
>	Ingo

In the instance I created, even the SysRq+b was ignored, and ISTR thats 
supposed to initiate a reboot is it not?  So it was well and truly wedged.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I use technology in order to hate it more properly.
		-- Nam June Paik
