Return-Path: <linux-kernel-owner+w=401wt.eu-S1761439AbZLPKuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439AbZLPKuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761371AbZLPKt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:49:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54851 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbZLPKtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:49:53 -0500
Date: Wed, 16 Dec 2009 11:49:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, minchan.kim@gmail.com
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
Message-ID: <20091216104951.GD15031@basil.fritz.box>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com> <20091216101107.GA15031@basil.fritz.box> <20091216191312.f4655dac.kamezawa.hiroyu@jp.fujitsu.com> <20091216102806.GC15031@basil.fritz.box> <20091216193109.778b881b.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216193109.778b881b.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 07:31:09PM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 16 Dec 2009 11:28:06 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > > Also the patches didn't fare too well in testing unfortunately.
> > > > 
> > > > I suspect we'll rather need multiple locks split per address
> > > > space range.
> > > 
> > > This set doesn't include any changes of the logic. Just replace all mmap_sem.
> > > I think this is good start point (for introducing another logic etc..)
> > 
> > The problem is that for range locking simple wrapping the locks
> > in macros is not enough. You need more changes.
> > 
> maybe. but removing scatterred mmap_sem from codes is the first thing to do.
> I think this removing itself will take 3 month or a half year.
> (So, I didn't remove mmap_sem and leave it as it is.)

I suspect you would just need to change them again then.

> The problem of range locking is more than mmap_sem, anyway. I don't think
> it's possible easily.

Yes, it has some tricky aspects. But my feeling is that there's no good
alternative to it for real scalability.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
