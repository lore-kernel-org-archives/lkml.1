Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbZH0JdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbZH0JdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZH0JdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:33:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:44596 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbZH0JdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:33:15 -0400
Subject: Re: spin_is_locked() broken for uniprocessor?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Linux-Kernel List <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1250674870.7583.334.camel@twins>
References: <alpine.LFD.2.00.0908190022570.3361@localhost.localdomain>
	 <DE9C9034-D2CE-4D21-93D9-A10FE2580920@kernel.crashing.org>
	 <7099.1250674686@redhat.com>  <1250674870.7583.334.camel@twins>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 19:32:34 +1000
Message-Id: <1251365554.20467.51.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 11:41 +0200, Peter Zijlstra wrote:
> > > > which implies to me that spin_is_locked() will always return
> false.  Is this
> > > > expected behavior.
> > > 
> > > That's wrong. spin_is_locked should always return true on UP.
> > 
> > Surely it's not that simple?  Maybe spin_is_lock() should be
> undefined on UP.
> 
> #define spin_is_locked(l) panic()
> 
> should sort things out quickly ;-)

Not defining it would sort things out even faster and avoid nasty case
of system panic'ing when a module is loaded :-)

Cheers,
Ben.


