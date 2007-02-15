Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbXBOFq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbXBOFq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 00:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbXBOFq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 00:46:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbXBOFq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 00:46:28 -0500
Date: Thu, 15 Feb 2007 00:45:59 -0500
From: Dave Jones <davej@redhat.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       herbert.xu@redhat.com, linux-kernel@vger.kernel.org,
       arjan@infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Message-ID: <20070215054559.GD15654@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andreas Gruenbacher <agruen@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
	herbert.xu@redhat.com, linux-kernel@vger.kernel.org,
	arjan@infradead.org, linux-crypto@vger.kernel.org
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <20070214194112.5bec3110.akpm@linux-foundation.org> <20070215041345.GA15654@redhat.com> <200702142135.40832.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702142135.40832.agruen@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 09:35:40PM -0800, Andreas Gruenbacher wrote:
 > On Wednesday 14 February 2007 20:13, Dave Jones wrote:
 > > I've not investigated it, but I hear rumours that suse has something
 > > similar.
 > 
 > Actually, no. We don't belive that module signing adds significant value,

ok, then I was misinformed.

 > and it also doesn't work well with external modules.

well, the situation for external modules is no worse than usual.
They still work, they just aren't signed. Which from a distributor point
of view, is actually a nice thing, as they stick out like a sore thumb
in oops reports with (U) markers :)

 > (The external modules we really care about are GPL ones; it gives us a way
 > to update drivers without pushing out entirely new kernels.)

external modules still compile, and run just fine. The signed modules code
doesn't prevent loading of them unless the user decides to do so with
a special boot option (which is no different really than say, reducing
the cap-bound sysctl to prevent module loading).

		Dave

-- 
http://www.codemonkey.org.uk
