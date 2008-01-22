Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbYAVOnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbYAVOnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYAVOnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:43:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55966 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbYAVOnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:43:13 -0500
Date: Tue, 22 Jan 2008 15:42:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Johannes Weiner <hannes@saeurebad.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zan Lynx <zlynx@acm.org>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: echo mem > /sys/power/state
Message-ID: <20080122144242.GK7304@elte.hu>
References: <20080117111355.29554f38.akpm@linux-foundation.org> <200801172238.17176.rjw@sisk.pl> <20080118083610.GA19792@elte.hu> <20080118004725.dcd132ee.akpm@linux-foundation.org> <20080118121803.GF11044@elte.hu> <20080120233912.GA4844@elf.ucw.cz> <20080120234208.GA22292@elte.hu> <20080121003106.GA1618@elf.ucw.cz> <878x2k53iz.fsf@saeurebad.de> <20080121223756.GA15875@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121223756.GA15875@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0027]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> Set alarm belongs in drivers/rtc, moved now.
> 
> > > +	alarm = now+length;
> > > +	rtc_time_to_tm(alarm, &alm.time);
> > > +
> > > +	retval = cmos_set_alarm(rtc, &alm);
> > 
> > cmos_set_alarm() takes a struct device * too.
> 
> Fixed.

any updated patch i could try? Thanks,

	Ingo
