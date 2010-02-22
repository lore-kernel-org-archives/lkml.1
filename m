Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab0BVKxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 05:53:30 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49141 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab0BVKx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 05:53:29 -0500
Message-ID: <4B826227.9010101@cs.helsinki.fi>
Date: Mon, 22 Feb 2010 12:53:27 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com,
       rientjes@google.com
Subject: Re: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
References: <20100211953.850854588@firstfloor.org> <20100211205404.085FEB1978@basil.firstfloor.org> <20100215061535.GI5723@laptop> <20100215103250.GD21783@one.firstfloor.org> <20100215104135.GM5723@laptop> <20100215105253.GE21783@one.firstfloor.org> <20100215110135.GN5723@laptop> <alpine.DEB.2.00.1002191222320.26567@router.home> <20100220090154.GB11287@basil.fritz.box>
In-Reply-To: <20100220090154.GB11287@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen kirjoitti:
> On Fri, Feb 19, 2010 at 12:22:58PM -0600, Christoph Lameter wrote:
>> On Mon, 15 Feb 2010, Nick Piggin wrote:
>>
>>> I'm just worried there is still an underlying problem here.
>> So am I. What caused the breakage that requires this patchset?
> 
> Memory hotadd with a new node being onlined.

So can you post the oops, please? Right now I am looking at zapping the 
series from slab.git due to NAKs from both Christoph and Nick.

			Pekka
