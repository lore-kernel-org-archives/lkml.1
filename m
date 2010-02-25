Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab0BYSqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:46:39 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55190 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034Ab0BYSqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:46:38 -0500
Message-ID: <4B86C58B.5040906@cs.helsinki.fi>
Date: Thu, 25 Feb 2010 20:46:35 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com,
       rientjes@google.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
References: <20100211953.850854588@firstfloor.org> <20100211205404.085FEB1978@basil.firstfloor.org> <20100215061535.GI5723@laptop> <20100215103250.GD21783@one.firstfloor.org> <20100215104135.GM5723@laptop> <20100215105253.GE21783@one.firstfloor.org> <20100215110135.GN5723@laptop> <alpine.DEB.2.00.1002191222320.26567@router.home> <20100220090154.GB11287@basil.fritz.box> <alpine.DEB.2.00.1002240949140.26771@router.home> <4B862623.5090608@cs.helsinki.fi> <alpine.DEB.2.00.1002251232550.18861@router.home>
In-Reply-To: <alpine.DEB.2.00.1002251232550.18861@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Christoph Lameter wrote:
>> OK, can we get this issue resolved? The merge window is open and Christoph
>> seems to be unhappy with the whole patch queue. I'd hate this bug fix to miss
>> .34...
> 
> Merge window? These are bugs that have to be fixed independently from a
> merge window. The question is if this is the right approach or if there is
> other stuff still lurking because we are not yet seeing the full picture.

The first set of patches from Andi are almost one month old. If this 
issue progresses as swiftly as it has to this day, I foresee a rocky 
road for any of them getting merged to .34 through slab.git, that's all.

			Pekka
