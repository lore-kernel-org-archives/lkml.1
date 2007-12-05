Return-Path: <linux-kernel-owner+w=401wt.eu-S1754317AbXLEKbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbXLEKbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbXLEKbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:31:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44121 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbXLEKbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:31:40 -0500
Date: Wed, 5 Dec 2007 11:31:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Holmes - Sun Microsystems <David.Holmes@Sun.COM>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH -v2] fix for futex_wait signal stack corruption
Message-ID: <20071205103111.GD22792@elte.hu>
References: <1196801858.1645.37.camel@localhost.localdomain> <alpine.LFD.0.9999.0712041307270.32379@woody.linux-foundation.org> <20071204213924.GA14915@goodmis.org> <alpine.LFD.0.9999.0712041436100.13796@woody.linux-foundation.org> <Pine.LNX.4.58.0712042016540.18042@gandalf.stny.rr.com> <alpine.LFD.0.9999.0712041740490.13796@woody.linux-foundation.org> <Pine.LNX.4.58.0712042135030.18314@gandalf.stny.rr.com> <alpine.LFD.0.9999.0712041935140.13796@woody.linux-foundation.org> <alpine.LFD.0.99999.0712050643440.3327@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.99999.0712050643440.3327@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Just a minor nit. Can we please use "futex" instead of "fu" ? I'm just 
> envisioning the next union member named "ba".
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Please apply with the s/fu/futex/ change. This needs to go into stable 
> .22/.23 as well.

ok, i've tied it all up, collected the Acks and will push Steve's fix to 
Linus via the scheduler git tree - is that fine with everyone? I think 
there's enough time to get this tested - Linus's latest tree shows up in 
Fedora rawhide in 1-2 days and tons of apps use futexes.

	Ingo
