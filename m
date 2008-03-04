Return-Path: <linux-kernel-owner+w=401wt.eu-S1760668AbYCDDwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760668AbYCDDwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:52:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbYCDDvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:51:53 -0500
Received: from ozlabs.org ([203.10.76.45]:60300 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbYCDDvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:51:53 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Jike Song" <albcamus@gmail.com>
Subject: Re: Module loading/unloading and "The Stop Machine"
Date: Tue, 4 Mar 2008 14:51:09 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Max Krasnyansky" <maxk@qualcomm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <47ABC08C.8010101@qualcomm.com> <df9815e70802132102v7eb7d8e9k4d6b21ffa6325d0d@mail.gmail.com>
In-Reply-To: <df9815e70802132102v7eb7d8e9k4d6b21ffa6325d0d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803041451.10312.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008 16:02:06 Jike Song wrote:
> On 2/8/08, Max Krasnyansky <maxk@qualcomm.com> wrote:
> > Hi Rusty,
> >
> > I was hopping you could answer a couple of questions about module
> > loading/unloading and the stop machine.
>
> I'm curious to know why it is called `stop machine', which is a queer
> name without any relationship with its function.

Hi Jike,

   I'm surprised.. stunned even, to hear you say this.  stop_machine stops the 
machine: every CPU is frozen with interrupts disabled.  I am having trouble 
thinking of a better name.

  "schedule_a_thread_on_every_cpu_and_then_disable_interrupts" is a little 
long, and describes the implementation not the effect.

  "run_and_make_sure_no_cpus_have_preempt_disabled" also fails the "will Linus 
flame me?" test, I think.

  "freeze_machine" has connotations of the freezer, which is completely 
different from this.  "do_machine" is shorter, but sounds vaguely naughty.

> Regards,
> Jike

Perhaps you were angling for "jike_machine"?  It's kind of catchy, but I don't 
think that patch will be accepted even if you pushed it as a git tree.

Cheers,
Rusty.
