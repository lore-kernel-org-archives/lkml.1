Return-Path: <linux-kernel-owner+w=401wt.eu-S1766743AbXDSOWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766743AbXDSOWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766730AbXDSOWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:22:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:38876 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766743AbXDSOWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:22:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UVVSrt5nHkYxt8eQkCx5Nq40aqRWlBV6tdjFfg8uM+Ht63Q3pbkcalpc2mydy88dVS269PKucwLdtduqVtV1aKDQIMwS2kGiOa2CAoaEC9kjBmwJa6Zm+foargMMUTMNMTUaVfXPg+K3R5Kvyd50T35Si50Cgr5xD07UeESgs1Y=
Message-ID: <75b66ecd0704190722l5ba8db7n52734c209504e802@mail.gmail.com>
Date: Thu, 19 Apr 2007 10:22:39 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Peter Williams" <pwil3058@bigpond.net.au>
Subject: Re: Renice X for cpu schedulers
Cc: "Con Kolivas" <kernel@kolivas.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Mike Galbraith" <efault@gmx.de>, "ck list" <ck@vds.kolivas.org>,
       "Bill Huey" <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <46276C83.40608@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070417062621.GL2986@holomorphy.com>
	 <20070418221432.e4dbcf4f.akpm@linux-foundation.org>
	 <20070419063810.GA22418@elte.hu>
	 <200704192159.35546.kernel@kolivas.org>
	 <462763A4.8080601@bigpond.net.au> <46276C83.40608@bigpond.net.au>
X-Google-Sender-Auth: 1bc4394d96181a27
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, Peter Williams <pwil3058@bigpond.net.au> wrote:
> PS I think that the tasks most likely to be adversely effected by X's
> CPU storms (enough to annoy the user) are audio streamers so when you're
> doing tests to determine the best nice value for X I suggest that would
> be a good criterion.  Video streamers are also susceptible but glitches
> in video don't seem to annoy users as much as audio ones.

IMHO audio streamers should use SCHED_FIFO thread for time critical
work.  I think it's insane to expect the scheduler to figure out that
these processes need low latency when they can just be explicit about
it.  "Professional" audio software does it already, on Linux as well
as other OS...

Lee
