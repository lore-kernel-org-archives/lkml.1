Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZLCLNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZLCLNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 06:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbZLCLNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 06:13:20 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:38309 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbZLCLNT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;6:1>);
	Thu, 3 Dec 2009 06:13:19 -0500
Message-Id: <4B17AB6102000078000235B0@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 03 Dec 2009 11:13:21 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] x86: slightly shorten __ticket_spin_trylock() (v2)
References: <4B179A6D0200007800023542@vpn.id2.novell.com>
 <20091203104906.GC7628@elte.hu>
In-Reply-To: <20091203104906.GC7628@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 03.12.09 11:49 >>>
>Looks much cleaner - and should give us pretty much the same savings as 
>the previous patch, right? (if not, do you have a size comparison?)

With upstream code there doesn't appear to be a difference in the
generated code. I noted, however, that with the spinlock contention
patch I have pending as a potential replacement for pv-ops spin locks
(which adds a conditional in the trylock functions) the compiler I use
no longer eliminates one of the two tests of the outcome of the
locking attempt.

Jan

