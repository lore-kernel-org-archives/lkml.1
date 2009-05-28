Return-Path: <linux-kernel-owner+w=401wt.eu-S1764594AbZE1Ugj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764594AbZE1Ugj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764175AbZE1Uga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:36:30 -0400
Received: from www.tglx.de ([62.245.132.106]:47657 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764297AbZE1Uga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:36:30 -0400
Date: Thu, 28 May 2009 22:36:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jon Hunter <jon-hunter@ti.com>
cc: john stultz <johnstul@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] Dynamic Tick: Prevent clocksource wrapping during
 idle
In-Reply-To: <4A1EF244.5040108@ti.com>
Message-ID: <alpine.LFD.2.00.0905282231500.3397@localhost.localdomain>
References: <4A1D52E3.3040204@ti.com>  <alpine.LFD.2.00.0905271731070.3397@localhost.localdomain> <1243455615.7440.17.camel@localhost.localdomain> <alpine.LFD.2.00.0905272229190.3397@localhost.localdomain> <4A1EF244.5040108@ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009, Jon Hunter wrote:
>  /**
> + * clocksource_max_deferment - Returns max time the clocksource can be
> deferred
> + * @cs:		Pointer to clocksource
> + *
> + */
> +static inline s64 clocksource_max_deferment(struct clocksource *cs)

  Please make this a real function. There is no reason to stick this
  into a header file. The only user is clocksource.c anyway, so please
  put it there as a static function and let the compiler decide what
  to do with it.

  Otherwise, I'm happy with it.

  Thanks,

	tglx
