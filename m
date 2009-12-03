Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbZLCP3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbZLCP3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbZLCP3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:29:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56275 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279AbZLCP3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 10:29:54 -0500
Date: Thu, 3 Dec 2009 16:29:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 2.6.32] x86: enable lapic nmi watchdog on AMD Family 11h
Message-ID: <20091203152952.GA27324@elte.hu>
References: <19223.53436.931768.278021@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19223.53436.931768.278021@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> The x86 lapic nmi watchdog does not recognize AMD Family 11h, 
> resulting in:
> 
> NMI watchdog: CPU not supported
> 
> As far as I can see from available documentation (the BKDM), family 
> 11h looks identical to family 10h as far as the PMU is concerned.
> 
> Extending the check to accept family 11h results in:
> 
> Testing NMI watchdog ... OK.
> 
> I've been running with this change on a Turion X2 Ultra ZM-82 laptop 
> for a couple of weeks now without problems.

Applied, thanks Mikael!

Long term i think we want to use the PMU driver to support the NMI tick, 
that way all new CPUs that have PMU support will get NMI watchdog 
support too, automatically.

That's a more complex change though and there's no reason not to apply 
this simple patch of yours. Btw., do you [or anyone else] have 
interest/time to pursue the more complex angle as well? It would be a 
nice feature.

	Ingo
