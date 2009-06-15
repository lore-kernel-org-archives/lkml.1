Return-Path: <linux-kernel-owner+w=401wt.eu-S1764138AbZFOQ70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764138AbZFOQ70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763098AbZFOQ7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:59:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52454 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763204AbZFOQ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:59:12 -0400
Date: Mon, 15 Jun 2009 19:07:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 00/22] HWPOISON: Intro (v5)
Message-ID: <20090615170726.GI31969@one.firstfloor.org>
References: <4A35BD7A.9070208@linux.vnet.ibm.com> <20090615042753.GA20788@localhost> <Pine.LNX.4.64.0906151341160.25162@sister.anvils> <20090615140019.4e405d37@lxorguk.ukuu.org.uk> <20090615132934.GE31969@one.firstfloor.org> <20090615154832.73c89733@lxorguk.ukuu.org.uk> <20090615152427.GF31969@one.firstfloor.org> <20090615162804.4cb75b30@lxorguk.ukuu.org.uk> <20090615161904.GH31969@one.firstfloor.org> <20090615172816.707bff0a@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615172816.707bff0a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But then if you
> can't sort the resulting mess out because your patches are too limited
> its not useful yet is it.

With "too limited" you refer to unpoisioning?

Again very slowly:

- If you have a lot of errors you die eventually anyways.
- If you have a very low rate of errors (which is the normal case) you don't 
need unpoisioning because the memory lost for each error is miniscule.
- In the case of a hypervisor it's actually not memory lost, but only
guest physical address space, which is plenty on a 64bit system. You can 
eventually replace it by readding memory to a guest, but that's unlikely
to be needed.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
