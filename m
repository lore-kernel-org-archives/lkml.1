Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbYKQSRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbYKQSRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYKQSQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:16:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468AbYKQSQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:16:57 -0500
Date: Mon, 17 Nov 2008 10:16:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <htejun@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix kunmap() argument in sg_miter_stop
In-Reply-To: <20081117180738.GW26778@kernel.dk>
Message-ID: <alpine.LFD.2.00.0811171015070.3468@nehalem.linux-foundation.org>
References: <20081117085046.GE28786@elte.hu> <20081117085807.GF26778@kernel.dk> <20081117093425.GG26778@kernel.dk> <20081117094147.GJ28786@elte.hu> <20081117094551.GI26778@kernel.dk> <20081117111350.GJ26778@kernel.dk> <4921A4F3.1030309@goop.org>
 <20081117171005.GA25729@elte.hu> <4921A6BE.7000206@goop.org> <alpine.LFD.2.00.0811170922000.3468@nehalem.linux-foundation.org> <20081117180738.GW26778@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, Jens Axboe wrote:
> 
> Any opinions on the kunmap/kunmap_atomic pointer checking? It's a bit
> ugly that we have to enforce a void * rule for kunmap_atomic(),

I don't think that's a "bit ugly". I think it's unacceptable.

Making sure we pass in "struct page" to kunmap() sounds good, but the 
kunmap_atomic() part just sounds insane.

		Linus
