Return-Path: <linux-kernel-owner+w=401wt.eu-S1766890AbXDSRfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766890AbXDSRfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766895AbXDSRfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:35:00 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:17110 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766890AbXDSRe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=c200GHxyzaiCw6ZXbHQnY3o16cQn3LA7UeEYqZ+v46zzOy2/ordalf4qrZfQGnFtkEOmVklNDKb4p6eCws+q33n/BiFG2JHQyNRlk3f++wOWRG7y90dznZ56U6QVs2AWT0HjGf12ADMIlzOb24u87MFmy82AexbK/B8W+Ow4V8s=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Thu, 19 Apr 2007 13:34:55 -0400
User-Agent: KMail/1.9.6
Cc: Willy Tarreau <w@1wt.eu>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu> <20070419125438.GA27584@1wt.eu> <20070419151803.GB30959@elte.hu>
In-Reply-To: <20070419151803.GB30959@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704191334.55649.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 April 2007, Ingo Molnar wrote:
>* Willy Tarreau <w@1wt.eu> wrote:
>> You can certainly script it with -geometry. But it is the wrong
>> application for this matter, because you benchmark X more than
>> glxgears itself. What would be better is something like a line
>> rotating 360 degrees and doing some short stuff between each degree,
>> so that X is not much sollicitated, but the CPU would be spent more on
>> the processes themselves.
>
>at least on my setup glxgears goes via DRI/DRM so there's no X
>scheduling inbetween at all, and the visual appearance of glxgears is a
>direct function of its scheduling.
>
>	Ingo

That doesn't appear to be the case here Ingo. Even when I know the rest of the 
system is lagged, glxgears continues to show very smooth and steady movement.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Yow!  I just went below the poverty line!
