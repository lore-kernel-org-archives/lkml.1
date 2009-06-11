Return-Path: <linux-kernel-owner+w=401wt.eu-S1763416AbZFKLm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763416AbZFKLm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763240AbZFKLmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:42:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:16294 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763113AbZFKLmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:42:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=btWFaOKb/1UVZ/GldUPJn2yYTytfOBerxbE+acKsigyk8DbHYsIBekZzTUz54ar8L
	7O/YH6qAVX4sJ7rRVj0+g==
MIME-Version: 1.0
In-Reply-To: <20090611111821.GK795@n2100.arm.linux.org.uk>
References: <20090610103131.GB13885@elf.ucw.cz>
	 <20090610194852.GA28787@n2100.arm.linux.org.uk>
	 <20090611.000219.206893038.davem@davemloft.net>
	 <20090611073740.GB8592@elf.ucw.cz>
	 <20090611103457.GG795@n2100.arm.linux.org.uk>
	 <a55d774e0906110412w7121d6d3t526ebd9c04d2d205@mail.gmail.com>
	 <20090611111821.GK795@n2100.arm.linux.org.uk>
Date: Thu, 11 Jun 2009 04:42:43 -0700
Message-ID: <a55d774e0906110442n396e343eya6e6a2bbd759465d@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       ibm@android.com, san@android.com, rlove@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 4:18 AM, Russell King - ARM
Linux<linux@arm.linux.org.uk> wrote:
> On Thu, Jun 11, 2009 at 04:12:39AM -0700, Brian Swetland wrote:
>> I think Andrew's idea is a good one, but we just haven't had the time
>> to try to sort this out.  I'll have to see what we can do here.
>> Recently, we've been involved in omap3 work as well and have been
>> interacting more with folks in the omap kernel community as a result.
>
> Brian,
>
> Can you clear up this thread, which seems to be descending into absurdness.

I've been trying to stay out of the non-practical side of things and
focus on what can be done to improve the process...

> David Miller seems to be of the opinion that I was rude or otherwise
> insulting to you.  Was this the case?

I've never felt that you were being rude or insulting.  The quality of
the feedback I've gotten on patches from you has been very high.  I
was a little frustrated with the last round of msm_serial.c review
which seemed to involve changing directions a couple times, but these
things happen.

> Was the only problem you had interacting with me to do with the time it
> takes to receive feedback on patches which you'd submitted and getting
> them merged?  I believe that caused you to question several times whether
> you were doing things in the right way.

The turnaround time on review is the biggest source of frustration --
I try not to get too bent out of shape about this as it's a lot of
code to ask somebody to review and you're obviously pretty busy at the
best of times.

The last time around I was trying to push out patches in little bursts
(5-10 at a time).  Not sure if that was too much or too little or so
on.  Since I tend to have time to work on cleanup for mainline when I
get downtime between projects/deadlines, I often end up with a big
pile of stuff and a fairly short amount of time in which I can react
to review.  I try to turn stuff around quickly in the face of
feedback.

In my ideal world (and I realize this doesn't really fit with the
general review model for the kernel), I'd love to get the baseline
mach-msm stuff (which doesn't impact stuff outside of that
architecture) that is stable and shipping in quite a few devices in
without completely gutting and rebuilding it, and then refine it from
there.

Brian
