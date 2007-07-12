Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbXGLGIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbXGLGIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 02:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbXGLGIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 02:08:17 -0400
Received: from brick.kernel.dk ([80.160.20.94]:8580 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbXGLGIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 02:08:16 -0400
Date: Thu, 12 Jul 2007 08:08:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tom Zanussi <zanussi@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dwilder@us.ibm.com
Subject: Re: [PATCH] relay: fix bogus cast in subbuf_splice_actor()
Message-ID: <20070712060814.GI4587@kernel.dk>
References: <1184186171.4517.33.camel@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184186171.4517.33.camel@ubuntu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11 2007, Tom Zanussi wrote:
> The current code that sets the read position in subbuf_splice_actor may
> give erroneous results if the buffer size isn't a power of 2.  This
> patch fixes the problem.

Thanks Tom, I just added this for my upstream branch, if you submit it
directly first, I'll just rebase without it again. Otherwise it'll go in
when I ask Linus to pull next.

-- 
Jens Axboe

