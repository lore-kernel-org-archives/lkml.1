Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZCLOAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZCLOAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbZCLN76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:59:58 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52794 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbZCLN76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:59:58 -0400
Date: Thu, 12 Mar 2009 07:59:40 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Message-ID: <20090312135940.GB14425@parisc-linux.org>
References: <200903110925.37614.phillips@phunq.net> <200903122203.31502.nickpiggin@yahoo.com.au> <200903120524.34150.phillips@phunq.net> <200903130004.40483.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903130004.40483.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 12:04:40AM +1100, Nick Piggin wrote:
> As far as the per-block pagecache state (as opposed to the per-block fs
> state), I don't see any reason it is a problem for efficiency. We have to
> do per-page operations anyway.

Why?  Wouldn't it be nice if we could do arbitrary extents?  I suppose
superpages or soft page sizes get us most of the way there, but the
rounding or pieces at the end are a bit of a pain.  Sure, it'll be a
huge upheaval for the VM, but we're good at huge upheavals ;-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
