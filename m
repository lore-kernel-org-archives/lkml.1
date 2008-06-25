Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbYFYT6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbYFYT6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbYFYT6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:58:10 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:44872 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbYFYT6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:58:09 -0400
Subject: Re: [PATCH 6/6] futex: fix miss ordered wakeups
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0806252053400.3297@apollo.tec.linutronix.de>
References: <20080624232018.817822790@mvista.com>
	 <20080624232020.505470899@mvista.com>  <1214371767.16881.5.camel@twins>
	 <1214404611.21035.20.camel@localhost.localdomain>
	 <1214406451.24356.13.camel@lappy.programming.kicks-ass.net>
	 <1214407507.21035.32.camel@localhost.localdomain>
	 <1214410654.24356.22.camel@lappy.programming.kicks-ass.net>
	 <1214412463.21035.57.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0806252053400.3297@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Wed, 25 Jun 2008 12:58:05 -0700
Message-Id: <1214423886.21035.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-06-25 at 21:06 +0200, Thomas Gleixner wrote:
> Unifying the mutex and the rtmutex blocked_on is semantically correct
> and is a worthwhile thing to do, but adding the futex waiter to it is
> simply a semantical brain fart which can not be excused by reducing
> the size of task struct.

I can unify just the rtmutex and the mutex, then add the futex waiter as
another entity.

Daniel

