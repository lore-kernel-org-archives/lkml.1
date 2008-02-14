Return-Path: <linux-kernel-owner+w=401wt.eu-S932905AbYBNH4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbYBNH4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 02:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbYBNH42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 02:56:28 -0500
Received: from mail.suse.de ([195.135.220.2]:53426 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbYBNH41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:56:27 -0500
Message-ID: <47B3F47C.8010803@suse.de>
Date: Thu, 14 Feb 2008 08:57:48 +0100
From: Andi Kleen <ak@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: make dump_pagetable() static
References: <20080213213131.GA3383@cs181133002.pp.htv.fi> <1202941667.18204.14.camel@brick> <20080213223621.GC12383@cs181133002.pp.htv.fi>
In-Reply-To: <20080213223621.GC12383@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Feb 13, 2008 at 02:27:47PM -0800, Harvey Harrison wrote:
>> On Wed, 2008-02-13 at 23:31 +0200, Adrian Bunk wrote:
>>> dump_pagetable() can now become static.
>>>
>>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>>>
>> I believe Andi Kleen wanted this kept global to make it easy to use when
>> adding debugging code elsewhere.
> 
> That's not a reason as long as his code isn't in the tree (and he anyway 
> has to patch the kernel for using it).

It was originally needed for the old cpa patchkit which dumped
the page tables when it detected an internal inconsistency
with the reference counts.

I think something like this would still make sense in a few
cases, although there are no reference counts to check anymore
currently.

-Andi
