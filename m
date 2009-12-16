Return-Path: <linux-kernel-owner+w=401wt.eu-S1761293AbZLPK2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761293AbZLPK2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbZLPK2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:28:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42726 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761263AbZLPK2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:28:08 -0500
Date: Wed, 16 Dec 2009 11:28:06 +0100
From: Andi Kleen <andi@firstfloor.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, minchan.kim@gmail.com
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
Message-ID: <20091216102806.GC15031@basil.fritz.box>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com> <20091216101107.GA15031@basil.fritz.box> <20091216191312.f4655dac.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216191312.f4655dac.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also the patches didn't fare too well in testing unfortunately.
> > 
> > I suspect we'll rather need multiple locks split per address
> > space range.
> 
> This set doesn't include any changes of the logic. Just replace all mmap_sem.
> I think this is good start point (for introducing another logic etc..)

The problem is that for range locking simple wrapping the locks
in macros is not enough. You need more changes.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
