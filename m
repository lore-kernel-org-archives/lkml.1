Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbYJBG5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbYJBG5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 02:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYJBG5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 02:57:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60802 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbYJBG53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 02:57:29 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
From: Andi Kleen <andi@firstfloor.org>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
Date: Thu, 02 Oct 2008 08:57:24 +0200
In-Reply-To: <20081001215638.3a65134c.akpm@linux-foundation.org> (Andrew Morton's message of "Wed, 1 Oct 2008 21:56:38 -0700")
Message-ID: <87fxnfpjqj.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 1 Oct 2008 20:00:34 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
>
>> Subject: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
>
> You proposed this a while back and it didn't happen and I forget
> why and the changelog doesn't mention any of that?

XFS tried this some time ago too.

I think the issue was that real user supplied RT applications don't want to 
compete with a "pseudo RT" kjournald.

So it would really need a new priority class between RT and normal priority.

-Andi

-- 
ak@linux.intel.com
