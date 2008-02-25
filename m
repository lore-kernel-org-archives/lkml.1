Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYBYHRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYBYHRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 02:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYBYHRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 02:17:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57370 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbYBYHRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 02:17:03 -0500
Date: Mon, 25 Feb 2008 08:16:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kmcmartin@redhat.com, lguest@ozlabs.org, rusty@rustcorp.com.au
Subject: Re: Linux 2.6.25-rc3
Message-ID: <20080225071605.GA11327@elte.hu>
References: <alpine.LFD.1.00.0802241354200.14934@woody.linux-foundation.org> <200802250129.17526.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802250129.17526.caglar@pardus.org.tr>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* S.Çağlar Onur <caglar@pardus.org.tr> wrote:

> 25 Şub 2008 Pts tarihinde, Linus Torvalds şunları yazmıştı: 
> > 
> > Ok, it's out there, ready for your enjoyment.
> [...] 
> > So give it a good testing, please,
> 
> -rc3 still fails for this [1] config

this is lguest breakage. I've got the fixes for it in x86.git, will push 
them to Linus later today if Rusty doesnt object.

> -#ifdef CONFIG_LGUEST
> +#if defined(CONFIG_LGUEST) || defined(CONFIG_LGUEST_MODULE)

this fix still fails for some randconfig combinations - the fuller fix 
is queued up in x86.git#testing.

	Ingo
