Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbZFBFVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbZFBFVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 01:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZFBFVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 01:21:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:48679 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbZFBFVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 01:21:03 -0400
Subject: Re: [PATCH 3/7] percpu: clean up percpu variable definitions
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tejun Heo <tj@kernel.org>
Cc: David Miller <davem@davemloft.net>, JBeulich@novell.com,
       andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, x86@kernel.org, ink@jurassic.park.msu.ru,
       rth@twiddle.net, linux@arm.linux.org.uk, hskinnemoen@atmel.com,
       cooloney@kernel.org, starvik@axis.com, jesper.nilsson@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
       takata@linux-m32r.org, geert@linux-m68k.org, monstr@monstr.eu,
       ralf@linux-mips.org, kyle@mcmartin.ca, paulus@samba.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, chris@zankel.net, rusty@rustcorp.com.au,
       jens.axboe@oracle.com, davej@redhat.com, jeremy@xensource.com,
       linux-mm@kvack.org
In-Reply-To: <4A23BD20.5030500@kernel.org>
References: <1243846708-805-1-git-send-email-tj@kernel.org>
	 <1243846708-805-4-git-send-email-tj@kernel.org>
	 <20090601.024006.98975069.davem@davemloft.net>
	 <4A23BD20.5030500@kernel.org>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 15:08:56 +1000
Message-Id: <1243919336.5308.32.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 20:36 +0900, Tejun Heo wrote:
> > Whether the volatile is actually needed or not, it's bad to have this
> > kind of potential behavior changing nugget hidden in this seemingly
> > inocuous change.  Especially if you're the poor soul who ends up
> > having to debug it :-/
> 
> You're right.  Aieee... how do I feed volatile to the DEFINE macro.
> I'll think of something.

Or better, work with the cris maintainer to figure out whether it's
needed (it probably isn't) and have a pre-requisite patch that removes
it before your series :-)

Cheers,
Ben.


