Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbYGAFlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbYGAFlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 01:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYGAFkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 01:40:55 -0400
Received: from saeurebad.de ([85.214.36.134]:50200 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbYGAFky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 01:40:54 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] softlockup: fix watchdog task wakeup frequency
References: <20080627000445.346130358@saeurebad.de>
	<20080627000805.504878592@saeurebad.de>
	<20080627120350.GB30872@elte.hu>
	<87prq3xdjv.fsf@skyscraper.fehenstaub.lan>
	<20080627124329.GA14576@elte.hu>
	<87d4m3xbzq.fsf@skyscraper.fehenstaub.lan>
	<87od5ms7yh.fsf@skyscraper.fehenstaub.lan>
	<20080630130837.GA332@elte.hu>
Date: Tue, 01 Jul 2008 07:40:17 +0200
In-Reply-To: <20080630130837.GA332@elte.hu> (Ingo Molnar's message of "Mon, 30
	Jun 2008 15:08:37 +0200")
Message-ID: <87abh26u2m.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo Molnar <mingo@elte.hu> writes:

> * Johannes Weiner <hannes@saeurebad.de> wrote:
>
>> > +	/*
>> > +	 * Wake up the high-prio watchdog task twice per
>> > +	 * threshold timespan.
>> > +	 */
>> > +	if (now > touch_timestamp + softlockup_thresh/2)
>> >  		wake_up_process(per_cpu(watchdog_task, this_cpu));
>> 
>> That defeats patch 1/3 and I think it can be dropped (#1).
>
> applied this updated patch to tip/core/softlockup. #3 didnt apply - 
> could you send a delta patch against tip/core/softlockup please? You can 
> pick it up via:
>
>   http://people.redhat.com/mingo/tip.git/README
>
> do:
>
>   git-checkout -b core/softlockup tip/core/softlockup
>
> to check it out.

Uhm, I see this patch is already in.  Misunderstanding or did you fix it
up yourself?

	Hannes
