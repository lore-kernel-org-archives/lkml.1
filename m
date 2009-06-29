Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbZF2XzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbZF2XzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZF2XzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:55:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59955 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbZF2XzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:55:07 -0400
Date: Tue, 30 Jun 2009 01:55:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [numbers] perfmon/pfmon overhead of 17%-94%
Message-ID: <20090629235500.GB5869@elte.hu>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy> <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy> <Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy> <20090627060432.GB16200@elte.hu> <20090627064404.GA19368@elte.hu> <Pine.LNX.4.64.0906291354380.1404@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906291354380.1404@pianoman.cluster.toy>
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


* Vince Weaver <vince@deater.net> wrote:

>> Besides, you compare perfcounters to perfmon
>
> what else shoud I be comparing it to?
>
>> (which you seem to be a contributor of)
>
> is that not allowed?

Here's the full, uncropped sentence i wrote:

 " Besides, you compare perfcounters to perfmon (which you seem to 
   be a contributor of), while in reality perfmon has much, much 
   worse (and unfixable, because designed-in) measurement overhead. "

Where i question the blatant hypocracy of bringing up perfmon as a 
good example while in reality perfmon has far worse measurement 
overhead than perfcounters, for a wide range of workloads.

As far as i can see you didnt answer my questions: why are you 
dismissing perfcounters for a minor, once per startup measurement 
offset (which is entirely fixable - see the patch i sent), while you 
generously allow perfmon to have serious, 90% measurement overhead 
amounting to billions of instructions overhead per second, for 
certain workloads?

	Ingo
