Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbYFLWsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbYFLWsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYFLWsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:48:13 -0400
Received: from www.tglx.de ([62.245.132.106]:60018 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbYFLWsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:48:12 -0400
Date: Fri, 13 Jun 2008 00:43:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ulrich Drepper <drepper@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5/5] futex: fix miss ordered wakeups
In-Reply-To: <1213308598.16459.82.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0806130023440.3193@apollo.tec.linutronix.de>
References: <20080611204916.271608740@mvista.com>  <20080611204917.523866467@mvista.com>  <alpine.LFD.1.10.0806121022250.3193@apollo.tec.linutronix.de>  <1213277402.16459.25.camel@localhost.localdomain>  <alpine.LFD.1.10.0806121533270.3193@apollo.tec.linutronix.de>
  <1213278286.16459.29.camel@localhost.localdomain>  <alpine.LFD.1.10.0806121636380.3193@apollo.tec.linutronix.de>  <1213286193.16459.53.camel@localhost.localdomain>  <alpine.LFD.1.10.0806121802050.3193@apollo.tec.linutronix.de>
 <1213308598.16459.82.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008, Daniel Walker wrote:

> 
> On Thu, 2008-06-12 at 21:55 +0200, Thomas Gleixner wrote:
> > Also your interpretation of the POSIX requirement is very
> > questionable:
> > 
> >  "If there are threads blocked on the mutex object referenced by mutex
> >  when pthread_mutex_unlock() is called, resulting in the mutex
> >  becoming available, the scheduling policy shall determine which
> >  thread shall acquire the mutex."
> 
> The key is "scheduling policy" .. When the mutex is un-blocked the next
> task to run is the same as if the scheduler was selecting tasks from the
> list of blocked tasks .. For Linux, that means the highest priority
> tasks should be selected.. So it's no more acceptable for the scheduler
> to priority invert some tasks than it is for the futex to do it.

Sigh, when do you actually get a gripe that the default futex
implementation does not and can not guarantee that at all and therefor
your "correctness" patch is as important as a bag of rice which
toopled over in China ?

Provide answers to the real questions I asked more than once: 

What's the real world problem ? Who cares about that - except you ?

Up to the point where you are actually able to come up with that
answers please direct your replies to /dev/null. That avoids that I
have to touch my .procmailrc.

Thanks,

	tglx
