Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZBCQHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZBCQHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZBCQHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:07:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47498 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbZBCQHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:07:22 -0500
Date: Tue, 3 Feb 2009 17:06:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ftrace: On PowerPC we don't need frame pointers for
	CALLER_ADDRs
Message-ID: <20090203160645.GA9020@elte.hu>
References: <20090131190650.GA4284@oksana.dev.rtsoft.ru> <1233534919.18767.69.camel@pasglop> <1233583455.16878.3.camel@localhost.localdomain> <20090203145649.GA19955@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203145649.GA19955@oksana.dev.rtsoft.ru>
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


* Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> According to this discussion:
> 
> http://lkml.org/lkml/2008/7/25/338
> http://lkml.org/lkml/2008/7/26/72
> 
> Frame pointers do nothing useful on PowerPC, so lib/Kconfig.debug
> makes CONFIG_FRAME_POINTER unselectable on PPC targets. But ftrace.h
> requires CONFIG_FRAME_POINTER for CALLER_ADDR macros. [...]

hm, why not add PPC to FRAME_POINTERS list of architectures, and select it 
from the powerpc arch Kconfig? Does that cause complications somewhere?

	Ingo
