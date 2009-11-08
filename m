Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbZKHKTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbZKHKTH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 05:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZKHKTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 05:19:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54250 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbZKHKTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 05:19:03 -0500
Date: Sun, 8 Nov 2009 11:18:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: ling.ma@intel.com, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
Message-ID: <20091108101856.GA7409@elte.hu>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com>
 <87my2z7g1b.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87my2z7g1b.fsf@basil.nowhere.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> ling.ma@intel.com writes:
> 
> > Intel Nehalem improves the performance of REP strings significantly
> > over previous microarchitectures in several ways:
> 
> The problem is that it's not necessarily a win on older CPUs to do it 
> this way.

I'm wondering, why are you writing such obtruse comments to Intel 
submitted patches? I know it and you know it too which older CPUs have a 
slow string implementation, and you know the rough order of magnitude 
and significance as well and you have ideas how to solve it all.

Instead you injected just the minimal amount of information into this 
thread to derail this patch you can see a problem with, but you didnt at 
all explain your full opinion openly and honestly and you certainly 
didnt give enough information to allow Ling Ma to act upon your opinion 
with maximum efficiency.

I.e. you are not being helpful at all here and you are obstructing Intel 
folks actively, making their workflow and progress as inefficient as you 
possibly can. Why are you doing that?

	Ingo
