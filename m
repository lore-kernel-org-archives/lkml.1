Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbXCPKOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbXCPKOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 06:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbXCPKOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 06:14:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37737 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbXCPKOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 06:14:43 -0400
Date: Fri, 16 Mar 2007 11:13:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH take3 00/20] Make common x86 arch area for i386 and x86_64 - Take 3
Message-ID: <20070316101351.GA4185@elte.hu>
References: <20070315051337.488091591@goodmis.org> <1173940659.19022.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173940659.19022.79.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Moving the rest of the files across to xxx_32.c, xxx_64.h etc is going 
> to involve a great deal of untangling and code cleanup.  It's also 
> going to completely screw a whole heap of my cleanup patches.  Oh 
> well.

most of your cleanups ought to be fixable via transforming the file 
names. But yes, and you are not the only one with some significant 
amount of x86 code pending - still, it's the right way to go ;-)

	Ingo
