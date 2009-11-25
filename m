Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbZKYKmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbZKYKmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758625AbZKYKmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:42:36 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52597 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZKYKmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:42:36 -0500
Message-ID: <4B0D0A21.1040205@cs.helsinki.fi>
Date: Wed, 25 Nov 2009 12:42:41 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: paulmck@linux.vnet.ibm.com, linux-mm@kvack.org, cl@linux-foundation.org,
       mpm@selenic.com, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
References: <20091118181202.GA12180@linux.vnet.ibm.com>	 <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com>	 <1258709153.11284.429.camel@laptop>	 <84144f020911200238w3d3ecb38k92ca595beee31de5@mail.gmail.com>	 <1258714328.11284.522.camel@laptop> <4B067816.6070304@cs.helsinki.fi>	 <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop>	 <20091124162311.GA8679@linux.vnet.ibm.com>	 <84144f020911241259r3a604b29yb59902655ec03a20@mail.gmail.com> <1259097990.4531.1843.camel@laptop>
In-Reply-To: <1259097990.4531.1843.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra kirjoitti:
> On Tue, 2009-11-24 at 22:59 +0200, Pekka Enberg wrote:
> 
>> Thanks! Please let me know when you're hammered it enough :-). Peter,
>> may I have your ACK or NAK on the patch, please?
> 
> Well, I'm not going to NAK it, for I think it does clean up that
> recursion crap a little, but it should have more merit that
> side-stepping lockdep.
> 
> If you too feel it make SLAB ever so slightly more palatable then ACK,
> otherwise I'm perfectly fine with letting SLAB bitrot.

I'll take that as an ACK ;-) Thanks!
