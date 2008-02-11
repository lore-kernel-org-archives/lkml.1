Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbYBKOEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbYBKOEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 09:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYBKOEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 09:04:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42826 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbYBKOEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 09:04:34 -0500
Date: Mon, 11 Feb 2008 15:04:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/8] CPA: Remove inline from static_protections
Message-ID: <20080211140419.GA16255@elte.hu>
References: <200802111050.372086035@suse.de> <20080211095017.6708F1B41CE@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211095017.6708F1B41CE@basil.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2351]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> The function is huge and called three times, so don't inline it.

thanks, applied. As most inlines it started out small ;-)

	Ingo
