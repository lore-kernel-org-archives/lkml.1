Return-Path: <linux-kernel-owner+w=401wt.eu-S1751564AbXBOGPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbXBOGPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 01:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbXBOGPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 01:15:05 -0500
Received: from ns1.suse.de ([195.135.220.2]:41046 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbXBOGPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 01:15:03 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Wed, 14 Feb 2007 22:14:53 -0800
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       herbert.xu@redhat.com, linux-kernel@vger.kernel.org,
       arjan@infradead.org, linux-crypto@vger.kernel.org
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <200702142135.40832.agruen@suse.de> <20070215054559.GD15654@redhat.com>
In-Reply-To: <20070215054559.GD15654@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702142214.53625.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 February 2007 21:45, Dave Jones wrote:
> well, the situation for external modules is no worse than usual.
> They still work, they just aren't signed. Which from a distributor point
> of view, is actually a nice thing, as they stick out like a sore thumb
> in oops reports with (U) markers :)

I agree, that's really what should happen. We solve this by marking modules as 
supported, partner supported, or unsupported, but in an "insecure" way, so 
partners and users could try to fake the support status of a module and/or 
remove status flags from Oopses, and cryptography wouldn't save us. We could 
try to sign Oopses which I guess you guys are doing. This whole issue hasn't 
been a serious problem in the past though, and we generally try to trust 
users not to play games on us.

In the end, it all seems to boils down to a difference in philosophy.

Thanks,
Andreas
