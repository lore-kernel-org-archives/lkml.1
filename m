Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbXKJLqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbXKJLqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 06:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbXKJLqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 06:46:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32803 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbXKJLqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 06:46:11 -0500
Subject: Re: [patch 2/2] fs: buffer trylock rename
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20071110051501.GB16018@wotan.suse.de>
References: <20071110051222.GA16018@wotan.suse.de>
	 <20071110051501.GB16018@wotan.suse.de>
Content-Type: text/plain
Date: Sat, 10 Nov 2007 12:44:31 +0100
Message-Id: <1194695071.20832.24.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-11-10 at 06:15 +0100, Nick Piggin wrote:
> fs: rename buffer trylock
> 
> Converting the buffer lock to new bitops also requires name change, so convert
> the raw test_and_set bitop to a trylock.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>

Looks simple enough, I'll look into doing a lockdep annotation for it
some time.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

