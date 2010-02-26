Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab0BZKOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:14:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51090 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab0BZKOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:14:38 -0500
Date: Fri, 26 Feb 2010 11:14:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Luca Barbieri <luca@luca-barbieri.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] x86-32: improve atomic64_t functions (v2)
Message-ID: <20100226101423.GA25641@elte.hu>
References: <1266600404-16402-1-git-send-email-luca@luca-barbieri.com>
 <4B845AEE.5080604@zytor.com>
 <ff13bc9a1002240156x27e28764mb6ba24da0b125d81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff13bc9a1002240156x27e28764mb6ba24da0b125d81@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luca Barbieri <luca@luca-barbieri.com> wrote:

> > I wonder if I could ask you to recreate your patchset on top of the
> > x86/asm branch in the -tip tree.
> 
> Done, resent.

FYI, it triggered build failures in -tip testing:

lib/atomic64_test.c: In function 'test_atomic64':
lib/atomic64_test.c:116: error: implicit declaration of function 'atomic64_dec_if_positive'

	Ingo
