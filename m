Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYCUMgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYCUMgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 08:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbYCUMgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 08:36:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41393 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347AbYCUMgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 08:36:11 -0400
Date: Fri, 21 Mar 2008 13:35:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] x86: merge the simple bitops and move them to
	bitops.h
Message-ID: <20080321123548.GL25225@elte.hu>
References: <20080312200128.GA24983@mailshack.com> <47DABEFB.3050704@goop.org> <1205523826.7441.1242464129@webmail.messagingengine.com> <20080314203526.GA13959@mailshack.com> <20080314163037.e15a49db.randy.dunlap@oracle.com> <20080315120442.GA21183@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080315120442.GA21183@mailshack.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0016]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> x86: merge the simple bitops and move them to bitops.h.
> 
> Some of those can be written in such a way that the same inline 
> assembly can be used to generate both 32 bit and 64 bit code.
> 
> For ffs and fls, x86_64 unconditionally used the cmov instruction and 
> i386 unconditionally used a conditional branch over a mov instruction. 
> In the current patch I chose to select the version based on the 
> availability of the cmov instruction instead. A small detail here is 
> that x86_64 did not previously set CONFIG_X86_CMOV=y.
> 
> Improved comments for ffs, ffz, fls and variations.

thanks Alexander, applied.

	Ingo
