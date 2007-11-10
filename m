Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbXKJLpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbXKJLpj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 06:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbXKJLpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 06:45:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32796 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbXKJLpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 06:45:31 -0500
Subject: Re: [patch 1/2] mm: page trylock rename
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20071110051222.GA16018@wotan.suse.de>
References: <20071110051222.GA16018@wotan.suse.de>
Content-Type: text/plain
Date: Sat, 10 Nov 2007 12:43:19 +0100
Message-Id: <1194694999.20832.22.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-11-10 at 06:12 +0100, Nick Piggin wrote:
> Hi,
> 
> OK minus the memory barrier changes for now. Can we possibly please
> get these into 2.6.24?
> 
> --
> mm: rename page trylock
> 
> Converting page lock to new locking bitops requires a change of page flag
> operation naming, so we might as well convert it to something nicer
> (!TestSetPageLocked => trylock_page, SetPageLocked => set_page_locked).
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

