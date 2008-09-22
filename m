Return-Path: <linux-kernel-owner+w=401wt.eu-S1752636AbYIVIaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbYIVIaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 04:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYIVIaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 04:30:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56613 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbYIVIaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 04:30:04 -0400
Date: Mon, 22 Sep 2008 10:29:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] x86: use round_jiffies() for the corruption check timer
Message-ID: <20080922082949.GD6601@elte.hu>
References: <20080920203544.53a5148e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080920203544.53a5148e@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> 
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sat, 20 Sep 2008 20:32:43 -0700
> Subject: [PATCH] x86: use round_jiffies() for the corruption check timer
> 
> the exact timing of the corruption check isn't too important (it's once a
> minute timer), use round_jiffies() to align it and avoid extra wakeups.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> CC: Hugh Dickins <hugh@veritas.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

applied to tip/x86/memory-corruption-check, thanks Arjan!

	Ingo
