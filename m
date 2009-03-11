Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZCKLsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZCKLsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 07:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZCKLsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 07:48:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49577 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbZCKLsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 07:48:01 -0400
Date: Wed, 11 Mar 2009 12:47:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: suggest running a 64bit kernel on LM capable
	machines with plenty memory.
Message-ID: <20090311114745.GG2282@elte.hu>
References: <49B254C6.8010507@pardus.org.tr> <20090307193026.GA2165@x200.localdomain> <49B2CE44.4060305@pardus.org.tr> <87r617ojfi.fsf@firstfloor.org> <1236606168.8389.512.camel@laptop> <20090309191504.GB11935@one.firstfloor.org> <1236677828.25234.9.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236677828.25234.9.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Something like the below?

> +#define MSG_LM_TRIMMED \
> +	"Warning: instead of using a 32bit %s kernel, Use a 64bit kernel!\n"

Sounds good, but please change the message to something like:

  INFO: running a 32-bit %s kernel on a 64-bit capable CPU!

To not overwhelm Arjan's kerneloops.org site with a hundred 
thousand bogus warnings ;-)

	Ingo
