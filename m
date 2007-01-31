Return-Path: <linux-kernel-owner+w=401wt.eu-S1030335AbXAaRTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030335AbXAaRTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030337AbXAaRTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:19:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58461 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030335AbXAaRTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:19:34 -0500
Date: Wed, 31 Jan 2007 18:18:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 10/23] clocksource: remove update_callback
Message-ID: <20070131171812.GD4468@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033806.127340327@mvista.com> <20070131104610.GA740@elte.hu> <1170258125.9781.50.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170258125.9781.50.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> On Wed, 2007-01-31 at 11:46 +0100, Ingo Molnar wrote:
> > * Daniel Walker <dwalker@mvista.com> wrote:
> > 
> > > Uses the block notifier to replace the functionality of 
> > > update_callback(). update_callback() was a special case specifically 
> > > for the tsc, but including it in the clocksource structure duplicated 
> > > it needlessly for other clocks.
> > 
> > Firstly, it think it should be mentioned that Thomas' queue already 
> > does this, in clocksource-remove-the-update-callback.patch (hence he 
> > should have been Cc:-ed). Your queue 'drops' Thomas' patch then 
> > redoes it here without mentioning that this is another version of 
> > what is in Thomas's queue. So we get this situation:
> > 
> >    clocksource-remove-the-update-callback.patch
> >    drop-clocksource-remove-the-update-callback.patch
> >    clocksource_remove_update_callback.patch
> > 
> > that all flip-flops the same thing.
> 
> To be clear this change has exists for a very long time, long before 
> Thomas implemented it ..

it doesnt matter who invented the wheel first, what matters is a clean 
channel of communication so that we end up with the best code - and 
leaving out Cc:s doesnt really help that.

	Ingo
