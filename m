Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbZCLMcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbZCLMcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbZCLMcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:32:35 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50290 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385AbZCLMcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:32:33 -0400
Date: Thu, 12 Mar 2009 06:32:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Daniel Phillips <phillips@phunq.net>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Message-ID: <20090312123230.GA14425@parisc-linux.org>
References: <200903110925.37614.phillips@phunq.net> <200903120315.07610.phillips@phunq.net> <200903122203.31502.nickpiggin@yahoo.com.au> <200903120524.34150.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903120524.34150.phillips@phunq.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 05:24:33AM -0700, Daniel Phillips wrote:
> On Thursday 12 March 2009, Nick Piggin wrote:
> > That's interesting. Do you handle 1K block sizes with 64K page size? :)
> 
> Not in its current incarnation.  That would require 32 bytes worth of
> state while the current code just has a 4 byte map (4 bits X 8 blocks).
> I suppose a reasonable way to extend it would be 4 x 8 byte maps.  Has
> somebody spotted a 64K page?

I believe SGI ship their ia64 kernels configured this way.  Certainly
16k ia64 kernels are common, which would (if I understand your scheme
correctly) be 8 bytes worth of state in your scheme.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
