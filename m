Return-Path: <linux-kernel-owner+w=401wt.eu-S1764101AbYDPNTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764101AbYDPNTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757029AbYDPNT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 09:19:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51319 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024AbYDPNT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:19:28 -0400
Date: Wed, 16 Apr 2008 15:19:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Mayer <ajm@sgi.com>
Cc: torvalds@linux-foundation.org,
       linux-kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Change FIRST_SYSTEM_VECTOR to a variable.
Message-ID: <20080416131914.GJ6304@elte.hu>
References: <Pine.SGI.3.96.1080415153530.8706317k-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SGI.3.96.1080415153530.8706317k-100000@fergus.americas.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1504]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Mayer <ajm@sgi.com> wrote:

> The SGI UV system needs several more system vectors than a vanilla 
> x86_64 system.  Rather than burden the other archs with extra system 
> vectors that they don't use, change FIRST_SYSTEM_VECTOR to a variable, 
> so that it can be dynamic.

thanks Alan, this looks really clean - i applied it to x86.git for more 
testing.

	Ingo
