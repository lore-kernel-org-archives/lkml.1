Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbYBDKhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbYBDKhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 05:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbYBDKgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 05:36:54 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:39317 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbYBDKgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 05:36:53 -0500
Subject: Re: [patch 2/3] CONFIG_HIGHPTE vs. sub-page page tables.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080202215315.3ac6907d.akpm@linux-foundation.org>
References: <20071112143009.425807965@de.ibm.com>
	 <20071112144009.831296895@de.ibm.com>
	 <20080201151541.8e3e0359.akpm@linux-foundation.org>
	 <1202017020.7208.2.camel@pasglop>
	 <20080202215315.3ac6907d.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 04 Feb 2008 11:36:49 +0100
Message-Id: <1202121409.31801.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-02-02 at 21:53 -0800, Andrew Morton wrote:
> On Sun, 03 Feb 2008 16:37:00 +1100 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > Why dropping add-mm-argument-to-pte-pmd-pud-pgd_free.patch though ?
> 
> I dropped the whole series.

Sniff .. my patches .. ;-)

> > It's a sane patch and a helps going further, and a total pain to re-do
> > later on. Besides, I may have some use for it on powerpc at some point
> > too...
> 
> OK, I'll try to reestablish it.

Fine. I've got the patch-merge message, so the first of the series is
done. 

> Look: I can't fix *everyone's* stuff.  This was a consequence of ongoing
> unbounded churn in the x86 tree.  If we can find a way of preventing those
> guys (and everyone else) from trashing everyone else's stuff then we'd have
> much smoother sailing.

Understood. That is where I jump in and regenerate my patches on the
latest available level. That the patches did hold up for some months in
-mm now without really breaking anything is an indication that we can
push them upstream now, isn't ? That would make the patch problem go
away and I could queue my s390 specific page table rework. Our KVM
people keep asking about it.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


