Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbZDWI2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbZDWI2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbZDWI1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 04:27:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36595 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbZDWI1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 04:27:53 -0400
Date: Thu, 23 Apr 2009 10:27:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 microcode: work_on_cpu and cleanup of the
	synchronization logic
Message-ID: <20090423082704.GD599@elte.hu>
References: <1240258569.6195.8.camel@earth> <1240344440.5861.10.camel@earth> <1240439073.12721.23.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240439073.12721.23.camel@earth>
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> Version 3
> 
> diff with v.2
> 
> - use smp_call_function_single() instead of work_on_cpu() as suggested by Ingo;
> - add 'enum ucode_state' as return value of request_microcode_{fw,user}
> - minor cleanups

This version looks really nice structurally. What type of testing 
have you done on the patch, on what CPU type?

Thanks,

	Ingo
