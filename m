Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbZLPKeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbZLPKeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbZLPKeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:34:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41097 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbZLPKeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:34:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Dec 2009 19:31:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, minchan.kim@gmail.com
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
Message-Id: <20091216193109.778b881b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091216102806.GC15031@basil.fritz.box>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
	<20091216101107.GA15031@basil.fritz.box>
	<20091216191312.f4655dac.kamezawa.hiroyu@jp.fujitsu.com>
	<20091216102806.GC15031@basil.fritz.box>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009 11:28:06 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > > Also the patches didn't fare too well in testing unfortunately.
> > > 
> > > I suspect we'll rather need multiple locks split per address
> > > space range.
> > 
> > This set doesn't include any changes of the logic. Just replace all mmap_sem.
> > I think this is good start point (for introducing another logic etc..)
> 
> The problem is that for range locking simple wrapping the locks
> in macros is not enough. You need more changes.
> 
maybe. but removing scatterred mmap_sem from codes is the first thing to do.
I think this removing itself will take 3 month or a half year.
(So, I didn't remove mmap_sem and leave it as it is.)

The problem of range locking is more than mmap_sem, anyway. I don't think
it's possible easily.

But ok, if no one welcome this, I stop this.

Thanks,
-Kame

