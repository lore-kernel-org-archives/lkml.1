Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbYBJJlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbYBJJlg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYBJJlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:41:24 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:53814 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190AbYBJJlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:41:19 -0500
Subject: Re: CONFIG_HIGHPTE vs. sub-page page tables.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0802100125va445d5ci81122da279b80d5f@mail.gmail.com>
References: <200802081902.m18J2nOm005840@hera.kernel.org>
	 <20080208230433.GA8524@elte.hu> <20080208231506.GA13350@elte.hu>
	 <1202551589.8936.1.camel@localhost> <20080209103728.GA29375@elte.hu>
	 <1202554574.8936.15.camel@localhost>
	 <8bd0f97a0802090956r2de999fap7f16e173858be240@mail.gmail.com>
	 <1202635061.21652.8.camel@localhost>
	 <8bd0f97a0802100125va445d5ci81122da279b80d5f@mail.gmail.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sun, 10 Feb 2008 10:41:08 +0100
Message-Id: <1202636468.21652.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-02-10 at 04:25 -0500, Mike Frysinger wrote:
> i guess my point was more: the pgtable_t typdef is new therefore it
> must be defined for every architecture.  your ability to directly
> cross-compile and/or test a subset is great, but posting a change that
> is know for a fact to break arches you didnt update seems like a bad
> idea.  even if you just included the obvious-but-not-compile-tested
> changes and included the linux-arch@vger alias instead would have been
> better than nothing
> -mike

The patch was posted multiple times on linux-arch and it has been part
of -mm for 3 months. Plenty of time for the arch maintainers to notice.
And without the pte_pfn_t change it would compile on a nommu
architecture even without the typedef. That is why I didn't add the new
typedef to the nommu archs. Which turned out to be a mistake after the
pte_pfn_t change has been added but the problem is fixed with the patch
sent yesterday, isn't?

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


