Return-Path: <linux-kernel-owner+w=401wt.eu-S1030853AbXEPVB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030853AbXEPVB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763227AbXEPVBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:01:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59875 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934377AbXEPVBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:01:08 -0400
X-Greylist: delayed 10572 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 May 2007 17:01:08 EDT
Date: Wed, 16 May 2007 23:01:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: v2.6.21-rt2
Message-ID: <20070516210104.GA17240@elte.hu>
References: <20070516180447.GA17922@elte.hu> <1179348842.20519.20.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179348842.20519.20.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> On Wed, 2007-05-16 at 20:04 +0200, Ingo Molnar wrote:
> > i'm pleased to announce the v2.6.20-rt2 kernel, which can be downloaded 
> > from the usual place:
> 
> 2.6.21-rt2 ?

oops, right! :-)

> >   - fixes for various problems by Steven Rostedt and Clark Williams
> 
> I think you missed the fix I submitted for one of Steve's changes.
> 
> http://lkml.org/lkml/2007/5/3/368

hm - trace_hardirqs_on() should never be called with irqs on - lockdep 
could break for example. Could you try to fix the call site instead?

	Ingo
