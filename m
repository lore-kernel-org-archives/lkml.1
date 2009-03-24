Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbZCXFoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbZCXFoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 01:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZCXFoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 01:44:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:43426 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbZCXFop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 01:44:45 -0400
Subject: Re: [PATCH] tracing: Fix TRACING_SUPPORT dependency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: avorontsov@ru.mvista.com
Cc: Ingo Molnar <mingo@elte.hu>, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090320202247.GA30654@oksana.dev.rtsoft.ru>
References: <20090320150914.GA22769@oksana.dev.rtsoft.ru>
	 <20090320190428.GD6224@elte.hu>
	 <20090320193904.GA13707@oksana.dev.rtsoft.ru>
	 <20090320195743.GA25147@elte.hu>
	 <20090320202247.GA30654@oksana.dev.rtsoft.ru>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 16:43:50 +1100
Message-Id: <1237873430.25062.715.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Weird, there's no lockdep support?
> 
> *ashamed*: apparently no such support currently exist for PPC32. ;-)

Actually there is a patch that's been floating around (from Dale
Farnsworth) for adding irqtrace/lockdep to ppc32 but it seems to be
buggy :-) IE, it causes crashes and I haven't had a chance
to try to find out yet. I'll probably give it another go one of these
days, but if you want to play with it, I'll send it to you directly.

Cheers,
Ben.


