Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbZCOEJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbZCOEJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 00:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbZCOEJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 00:09:07 -0400
Received: from phunq.net ([64.81.85.152]:58420 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751384AbZCOEJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 00:09:06 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Sat, 14 Mar 2009 21:08:52 -0700
User-Agent: KMail/1.9.9
Cc: Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903142024.30142.phillips@phunq.net> <200903151450.51726.nickpiggin@yahoo.com.au>
In-Reply-To: <200903151450.51726.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903142108.53155.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 March 2009, Nick Piggin wrote:
> On Sunday 15 March 2009 14:24:29 Daniel Phillips wrote:
> > I expect implementing VM extents to be a brutally complex project, as
> > filesystem extents always turn out to be, even though one tends to
> > enter such projects thinking, how hard could this be?  Answer: harder
> > than you think.  But VM extents would be good for a modest speedup, so
> > somebody is sure to get brave enough to try it sometime.
> 
> I don't think there is enough evidence to be able to make such an
> assertion.
> 
> When you actually implement extent splitting and merging in a deadlock
> free manner and synchronize everything properly I wouldn't be surprised
> if it is slower most of the time. If it was significantly faster, then
> memory fragmentation means that it is going to get significantly slower
> over the uptime of the kernel, so you would have to virtually map the
> kernel and implement memory defragmentation, at which point you get even
> slower and more complex.

You can make exactly the same argument about filesystem extents, and
we know that extents are faster there.  So what is the fundamental
difference?

Regards,

Daniel
