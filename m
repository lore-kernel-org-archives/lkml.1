Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbZKKJO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbZKKJO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 04:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbZKKJO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 04:14:29 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53966 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbZKKJO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 04:14:28 -0500
Date: Wed, 11 Nov 2009 09:14:31 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Peter Zijlstra <peterz@infradead.org>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net, glisse@freedesktop.org
Subject: Re: Radeon KMS status (Re: [git pull] drm radeon kms.)
In-Reply-To: <1257926475.23203.24.camel@twins>
Message-ID: <alpine.DEB.2.00.0911110910170.4943@skynet.skynet.ie>
References: <alpine.DEB.2.00.0911102313310.29664@skynet.skynet.ie> <1257926475.23203.24.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Dave,
> 
> I was wondering about the current state of Radeon KMS, how far are we
> from having it removed from staging?

I'm sort of thinking the next merge window of moving the enable option 
into the kernel proper. We still have a metric shitload of work to get to 
feature parity with current userspace drivers and we've done no 
optimisation work on the rendering portion of the stack so I'm not sure 
freezing the API isn't a bit premature, however maybe the API we have is 
good enough to support and we can add new ioctls to make it go faster if 
we require.

Jerome has proposed some API changes but we really haven't had time to 
validate them in any useful way.

Dave.
