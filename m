Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbZHPP00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbZHPP00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 11:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbZHPP0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 11:26:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54622 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbZHPP0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 11:26:25 -0400
Date: Sun, 16 Aug 2009 17:26:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Dmitry Torokhov <dtor@mail.ru>, "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, mce: therm_throt: don't log redundant normality
Message-ID: <20090816152613.GB17313@elte.hu>
References: <Pine.LNX.4.64.0908161544100.7929@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908161544100.7929@sister.anvils>
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


* Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> Hi Dmitry,
> 
> I'm delighted to find your 
> 0d01f31439c1e4d602bf9fdc924ab66f407f5e38 "x86, mce: therm_throt - 
> change when we print messages" in rc6: thank you.
> 
> I too had been annoyed by "critical" CPU1 Temperature/speed normal 
> messages, with no indication that anything had been abnormal: 
> after resume on a Fujitsu-Siemens Esprimo Mobile (whereas startup 
> decided the Duo's CPU0 Thermal monitoring would be handled by SMI 
> not by MCE).
> 
> I hadn't reported it yet, because I couldn't quite work out what 
> to do about it: your patch looks good, so long as someone else 
> doesn't have a machine which jumps between throttled and 
> unthrottled too quickly.
> 
> But could we add one more thing on top of your patch?  Though it 
> no longer keeps announcing "I am normal", can we please also get 
> rid of the accompanying "Machine check events logged" message too? 
> If the non-event isn't worth showing (I agree that it isn't), then 
> I think it's not worth logging either.

Yeah, makes sense - i've queued it up, thanks Hugh!

	Ingo
