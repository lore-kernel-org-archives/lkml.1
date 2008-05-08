Return-Path: <linux-kernel-owner+w=401wt.eu-S1763600AbYEHQ23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763600AbYEHQ23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYEHQ2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:28:20 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:11321 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbYEHQ2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:28:19 -0400
Subject: Re: futex: priority wakeup miss ordering
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pierre Peiffer <peifferp@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0805081156450.3318@apollo.tec.linutronix.de>
References: <1210195378.17132.237.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805081156450.3318@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Thu, 08 May 2008 09:28:17 -0700
Message-Id: <1210264097.17132.261.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-08 at 12:06 +0200, Thomas Gleixner wrote:

> IIRC this has been discussed before. The priority ordering of the
> plain mutex waiters is an optimization without guarantees of
> correctness across a priority change. It's simply not worth the
> additional complexity and overhead for that corner case.

I've gotten a number of complains about this .. I think it's assumed
that this feature was implementing posix priority queuing for the
standard futex, but it can't be if there are any miss ordered wakeups.

Daniel

