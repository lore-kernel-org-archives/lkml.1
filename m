Return-Path: <linux-kernel-owner+w=401wt.eu-S1759009AbZLPKgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009AbZLPKgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758741AbZLPKgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:36:23 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42330 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbZLPKgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:36:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Dec 2009 19:33:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
Message-Id: <20091216193315.14a508d5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262360912160231r18db8478sf41349362360cab8@mail.gmail.com>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
	<20091216101107.GA15031@basil.fritz.box>
	<20091216191312.f4655dac.kamezawa.hiroyu@jp.fujitsu.com>
	<20091216102806.GC15031@basil.fritz.box>
	<28c262360912160231r18db8478sf41349362360cab8@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009 19:31:40 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Wed, Dec 16, 2009 at 7:28 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >> > Also the patches didn't fare too well in testing unfortunately.
> >> >
> >> > I suspect we'll rather need multiple locks split per address
> >> > space range.
> >>
> >> This set doesn't include any changes of the logic. Just replace all mmap_sem.
> >> I think this is good start point (for introducing another logic etc..)
> >
> > The problem is that for range locking simple wrapping the locks
> > in macros is not enough. You need more changes.
> 
> I agree.
> 
> We can't justify to merge as only this patch series although this
> doesn't change
> any behavior.
> 

> After we see the further works, let us discuss this patch's value.
> 
Ok, I'll show new version of speculative page fault.


> Nitpick:
> In case of big patch series, it would be better to provide separate
> all-at-once patch
> with convenience for easy patch and testing. :)
> 
Sure, keep it in my mind.

Thanks,
-Kame

