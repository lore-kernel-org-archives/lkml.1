Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080Ab0ANHCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab0ANHCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904Ab0ANHCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:02:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55270 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab0ANHCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:02:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH v5] add MAP_UNLOCKED mmap flag
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20100114065008.GC18808@redhat.com>
References: <20100114092845.D719.A69D9226@jp.fujitsu.com> <20100114065008.GC18808@redhat.com>
Message-Id: <20100114155229.6735.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 Jan 2010 16:02:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jan 14, 2010 at 09:31:03AM +0900, KOSAKI Motohiro wrote:
> > > If application does mlockall(MCL_FUTURE) it is no longer possible to mmap
> > > file bigger than main memory or allocate big area of anonymous memory
> > > in a thread safe manner. Sometimes it is desirable to lock everything
> > > related to program execution into memory, but still be able to mmap
> > > big file or allocate huge amount of memory and allow OS to swap them on
> > > demand. MAP_UNLOCKED allows to do that.
> > >  
> > > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> > > ---
> > > 
> > > I get reports that people find this useful, so resending.
> > 
> > This description is still wrong. It doesn't describe why this patch is useful.
> > 
> I think the text above describes the feature it adds and its use
> case quite well. Can you elaborate what is missing in your opinion,
> or suggest alternative text please?

My point is, introducing mmap new flags need strong and clearly use-case.
All patch should have good benefit/cost balance. the code can describe the cost,
but the benefit can be only explained by the patch description.

I don't think this poor description explained bit benefit rather than cost.
you should explain why this patch is useful and not just pretty toy.


