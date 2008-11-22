Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbYKVMfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbYKVMfY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 07:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588AbYKVMfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 07:35:08 -0500
Received: from qb-out-0506.google.com ([72.14.204.238]:3233 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438AbYKVMfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 07:35:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BTdQnxhe71Bt/g8NfkjKR+kPfNZJMZ0KDSUeV977L3hheL53eSCOhFtDtf30AcVoXv
         uI6HCeeXogQyjmHk/H4sT6aFQCtxn+GKiQK2x8qKRFOFgE14w05QhJCd+wFWDPSGvk9i
         X9O2LpyZa+H05Dv8YQzKSx+l0db5K3nSzQ1mE=
Message-ID: <19f34abd0811220435r38e749e3o425d994912fc92ea@mail.gmail.com>
Date: Sat, 22 Nov 2008 13:35:02 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] SLUB: use page allocator for PAGE_SIZE requests
Cc: "Mel Gorman" <mel@csn.ul.ie>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081122123230.GA27189@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081122123230.GA27189@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 1:32 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> From 4d526db4781aaab86cb79ff8135bb0e2bc560598 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Sat, 22 Nov 2008 13:27:54 +0100
> Subject: [PATCH] SLUB: use page allocator for PAGE_SIZE requests
>
> It seems strange that we should use the page allocator for
> requests of (PAGE_SIZE + 1) bytes or more, and not for requests
> that are exactly PAGE_SIZE.

Actually, there are some more places that need to be fixed. I think
I'll send an updated patch that fixes all of them.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
