Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbZA0Sar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbZA0Sar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbZA0Saj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:30:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49913 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbZA0Saj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:30:39 -0500
Subject: Re: [PATCH v2] timer: implement lockdep deadlock detection
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1233079597.4755.2.camel@johannes.local>
References: <1233010786.4344.1.camel@johannes.local>
	 <20090126230721.GA6556@elte.hu> <1233046009.4012.3.camel@johannes.local>
	 <20090127132759.GI23121@elte.hu>  <20090127134128.GA24965@elte.hu>
	 <1233079597.4755.2.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jan 2009 19:30:27 +0100
Message-Id: <1233081027.10992.21.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 19:06 +0100, Johannes Berg wrote:
> On Tue, 2009-01-27 at 14:41 +0100, Ingo Molnar wrote:
> > -tip testing found this build failure with your patch:
> > 
> >  arch/x86/kernel/hpet.c:631: error: too few arguments to function ‘init_timer_on_stack_key’
> 
> Odd, I'll look into this.
> 
> Meanwhile, I'd appreciate comments on
> http://bugzilla.kernel.org/show_bug.cgi?id=12552

Seems valid to me, the workaround in run_workqueue() seems applicable
here as well.

