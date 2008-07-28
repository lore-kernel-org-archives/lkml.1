Return-Path: <linux-kernel-owner+w=401wt.eu-S1758801AbYG1Amq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbYG1Amq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 20:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbYG1Amh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 20:42:37 -0400
Received: from ozlabs.org ([203.10.76.45]:38292 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbYG1Amg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 20:42:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] cpus4096 fixes
Date: Mon, 28 Jul 2008 10:42:12 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281042.12860.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008 06:15:26 Linus Torvalds wrote:
> On Sun, 27 Jul 2008, Ingo Molnar wrote:
> > Please pull the latest cpus4096-fixes git tree from:
>
> No. Not without explanations.
>
> Quite frankly, this "fix" looks like a huge stinking pile of sh*t.
>
> I can't follow that thread on lkml.org (horrible web interface with
> hard-to-follow threading), and I'm too lazy to bother to look in my lkml
> email archives, but whoever said
>
>   "The simple version is just a static array of [NR_CPUS] cpumask_t's."
>
> and then implemented this piece of shit is a complete and utter moron.

How awesome, Linus is talking about me!

Your idea is clever, thanks.  This patch was a bandaid to save us from the 
unbearably fugly "cpumask_of_cpu_ptr_declare(cpu_mask)".  I was going to rip 
this code out as soon as possible, but with your trick we should keep it.

The 4k CPU patches have been sliding in without review up until now.  We need 
a serious think about how to handle cpumask_t that doesn't fit on the stack.  

Hey, since Mike put his Signed-off-by above mine and didn't put a From line 
when he took my patch, WFT am I taking responsibility? :)

Rusty.
