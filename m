Return-Path: <linux-kernel-owner+w=401wt.eu-S1762664AbZFMLET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762664AbZFMLET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 07:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbZFMLEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 07:04:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57106 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbZFMLEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 07:04:02 -0400
Date: Sat, 13 Jun 2009 13:03:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 -tip] x86: perf_counter update AMD hw caching
	related event table
Message-ID: <20090613110352.GC18924@elte.hu>
References: <1244714289.6923.0.camel@ht.satnam> <1244714379.6923.2.camel@ht.satnam> <20090612173520.GB22015@elte.hu> <1244835318.2802.1.camel@ht.satnam> <1244835381.2802.2.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244835381.2802.2.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0336]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> [PATCH 2/2 -tip] x86: perf_counter update AMD hw caching related event table
> 
> AMD shares same hw caching related event table.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

> -		[ C(RESULT_ACCESS) ] = 0,
> -		[ C(RESULT_MISS)   ] = 0,
> +		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
> +		[ C(RESULT_MISS)   ] = 0x0041, /* Data Cache Misses          */

How did you get to these numbers and have you tested them? (Such 
information needs to be in the changelog)

	Ingo
