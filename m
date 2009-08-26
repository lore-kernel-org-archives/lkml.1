Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbZHZGM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbZHZGM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbZHZGM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:12:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58120 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756772AbZHZGM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:12:56 -0400
Date: Wed, 26 Aug 2009 08:12:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [rfc -tip 3/4] x86,apic: fix missed handling of discrete apics
Message-ID: <20090826061241.GC6194@elte.hu>
References: <20090824175335.186713800@openvz.org> <20090824175551.322214127@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824175551.322214127@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> +	if (!cpu_has_apic && (!smp_found_config || disable_apic))
> +	if (!cpu_has_apic && (!smp_found_config || disable_apic))
> +	if (cpu_has_apic || (smp_found_config && !disable_apic))

these are now repeating patterns, so that should be moved into a 
helper inline or so.

	Ingo
