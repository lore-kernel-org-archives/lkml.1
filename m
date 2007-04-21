Return-Path: <linux-kernel-owner+w=401wt.eu-S1752253AbXDUTty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbXDUTty (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 15:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXDUTty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 15:49:54 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:9129 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbXDUTtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 15:49:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mE708NIwrhAzS3sP4QvN+Jd7IORzSu9Hvy8K59J/30d25BxvBsaXxVLEZSkZyuWFF1fQJ7QP34XDwmyt1QKfNFVUSLmwHBsyTE1f9YlwCkBADClfi0H9Onx4q6Qu9+IYBcHvyJeCDklIgyI7cZ5A/KMQg2DvuY/+pyj1wLZQvoM=
Message-ID: <a36005b50704211249pb771b79k227914515b5f9906@mail.gmail.com>
Date: Sat, 21 Apr 2007 12:49:52 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Kyle Moffett" <mrmacman_g4@mac.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Cc: "William Lee Irwin III" <wli@holomorphy.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Willy Tarreau" <w@1wt.eu>, "Ingo Molnar" <mingo@elte.hu>,
       "Con Kolivas" <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>, "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, caglar@pardus.org.tr,
       "Gene Heskett" <gene.heskett@gmail.com>
In-Reply-To: <E1192E83-5E64-4782-8F92-DDCA09CA2F55@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu>
	 <20070421154614.GA26169@elte.hu> <20070421161818.GC7840@1wt.eu>
	 <alpine.LFD.0.98.0704210931370.9964@woody.linux-foundation.org>
	 <20070421164241.GF2986@holomorphy.com>
	 <E1192E83-5E64-4782-8F92-DDCA09CA2F55@mac.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/07, Kyle Moffett <mrmacman_g4@mac.com> wrote:
> It might be nice if it was possible to actively contribute your CPU
> time to a child process.  For example:
> int sched_donate(pid_t pid, struct timeval *time, int percentage);

If you do this, and it has been requested many a times, then please
generalize it.  We have the same issue with futexes.  If a FUTEX_WAIT
call is issues the remaining time in the slot should be given to the
thread currently owning the futex.  For non-PI futexes this needs an
extension of the interface but I would be up for that.  It can have
big benefits on the throughput of an application.
