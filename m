Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbZHMGxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbZHMGxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 02:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZHMGxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 02:53:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:43799 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbZHMGxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 02:53:31 -0400
Subject: Re: [PATCH] swap: send callback when swap slot is freed
From: Peter Zijlstra <peterz@infradead.org>
To: ngupta@vflare.org
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Matthew Wilcox <willy@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <4A837AAF.4050103@vflare.org>
References: <200908122007.43522.ngupta@vflare.org>
	 <Pine.LNX.4.64.0908122312380.25501@sister.anvils>
	 <4A837AAF.4050103@vflare.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 13 Aug 2009 08:53:00 +0200
Message-Id: <1250146380.10001.47.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 08:00 +0530, Nitin Gupta wrote:
> > I don't share Peter's view that it should be using a more general
> > notifier interface (but I certainly agree with his EXPORT_SYMBOL_GPL).
> 
> Considering that the callback is made under swap_lock, we should not 
> have an array of callbacks to do. But what if this callback finds other 
> users too? I think we should leave it in its current state till it finds 
> more users and probably add BUG() to make sure callback is not already set.
> 
> I will make it EXPORT_SYMBOL_GPL.

If its such a tightly coupled system, then why is compcache a module?
