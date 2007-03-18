Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbXCRNNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbXCRNNf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 09:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbXCRNNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 09:13:35 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:36092 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXCRNNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 09:13:34 -0400
Date: Sun, 18 Mar 2007 09:09:53 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Blaisorblade <blaisorblade@yahoo.it>, Bill Irwin <bill.irwin@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070318130953.GA2492@c2.user-mode-linux.org>
References: <20070221023735.6306.83373.sendpatchset@linux.site> <200703130001.13467.blaisorblade@yahoo.it> <20070313011904.GA2746@wotan.suse.de> <200703171317.01074.blaisorblade@yahoo.it> <20070318025010.GA1671@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318025010.GA1671@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 03:50:10AM +0100, Nick Piggin wrote:
> Yes, that should be the case. So would this mean that nonlinear protections
> don't work on regular files? I guess that's OK if Oracle and UML both use
> tmpfs/shm?

It's OK for UML.

		Jeff

-- 
Work email - jdike at linux dot intel dot com
