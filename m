Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbYEPMWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbYEPMWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 08:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYEPMV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 08:21:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38808 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbYEPMVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 08:21:55 -0400
Subject: Re: [patch] doc: add a chapter about trylock functions [Bug 9011]
From: Peter Zijlstra <peterz@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Matti Linnanvuori <mattilinn@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200805151030.18959.rusty@rustcorp.com.au>
References: <ca0148c30805130831h11fe0ca0qf501bd07d1141940@mail.gmail.com>
	 <200805151030.18959.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Fri, 16 May 2008 14:21:25 +0200
Message-Id: <1210940485.7886.29.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-15 at 10:30 +1000, Rusty Russell wrote:
> On Wednesday 14 May 2008 01:31:47 Matti Linnanvuori wrote:
> > +    <function>mutex_trylock()</function> does not suspend your task
> > +    but returns non-zero if it could lock the mutex on the first try
> > +    or 0 if not. This function cannot be safely used in hardware or
> > +    software interrupt contexts despite not sleeping.
> 
> I know this is what the documentation says, but I can't see why.  Ingo?

because who would then own the lock?

