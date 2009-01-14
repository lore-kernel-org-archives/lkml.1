Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbZANLUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbZANLUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbZANLUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:20:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37894 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234AbZANLUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:20:07 -0500
Date: Wed, 14 Jan 2009 12:19:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: arch_probe_nr_irqs
Message-ID: <20090114111949.GO2913@elte.hu>
References: <496AD835.6000509@kernel.org> <20090112091952.GI26750@elte.hu> <20090112092613.GA1822@elte.hu> <496B9FC3.7080306@kernel.org> <496BCD14.3020201@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496BCD14.3020201@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4998]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Yinghai Lu wrote:
> > Impact: save RAM with large NR_CPUS, get smaller nr_irqs
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Built and tested on an 8-core intel system.  Great reduction
> in NR_IRQS:
> 
> 	[    0.000000] NR_IRQS:33024 nr_irqs:320
> 
> Thanks Yinghai!
> 
> Ingo - shall I push this one as well?  (If not, then you
> can add my:
> 
> 	Acked-by: Mike Travis <travis@sgi.com>

yes, please pick it up and i can pull it from you. Please also add a 
longer changelog about the precise effects and perhaps some estimations 
about what the before and after situation is, and perhaps also some bits 
about how it affects normal Linux users as well.

	Ingo
