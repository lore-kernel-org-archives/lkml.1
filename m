Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbXHBCPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbXHBCPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 22:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbXHBCP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 22:15:27 -0400
Received: from mx1.suse.de ([195.135.220.2]:45631 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbXHBCP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 22:15:26 -0400
Date: Thu, 2 Aug 2007 04:15:25 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: lmbench ctxsw regression with CFS
Message-ID: <20070802021525.GC15595@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I didn't follow all of the scheduler debates and flamewars, so apologies
if this was already covered. Anyway.

lmbench 3 lat_ctx context switching time with 2 processes bound to a
single core increases by between 25%-35% on my Core2 system (didn't do
enough runs to get more significance, but it is around 30%). The problem
bisected to the main CFS commit.

I was really hoping that a smaller runqueue data structure could actually
increase performance with the common case of small numbers of tasks :(

I assume this was a known issue before CFS was merged. Do you know what is
causing the slowdown? Any plans to fix it?

Thanks,
Nick
