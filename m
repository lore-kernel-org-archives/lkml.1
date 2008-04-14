Return-Path: <linux-kernel-owner+w=401wt.eu-S1759158AbYDNM2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158AbYDNM2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYDNM2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:28:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56166 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbYDNM2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:28:19 -0400
Date: Mon, 14 Apr 2008 14:28:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andi Kleen <andi@firstfloor.org>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: always_inline wrapper for x86's test_bit
Message-ID: <20080414122802.GA20350@elte.hu>
References: <20080413112308.GA23426@mailshack.com> <87hce5wv2h.fsf@basil.nowhere.org> <1208109831.1489.1247631595@webmail.messagingengine.com> <20080413181642.GA8641@one.firstfloor.org> <1208175845.22460.1247749229@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208175845.22460.1247749229@webmail.messagingengine.com>
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


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> B.T.W., debian and ubuntu don't provide gcc-3.2 packages. Is there a 
> good reason why gcc-3.2.3 (5 years old in a week) should still be 
> supported?

we normally desupport given gcc versions only if their support in the 
kernel is very difficult and leads to lots of uglinesses, or if a gcc 
version is known to fatally miscompile the kernel, with no workaround 
available.

i.e. we try not to break people's build setups (folks with a specific 
gcc version in a cross-build setup), without a good reason.

	Ingo
