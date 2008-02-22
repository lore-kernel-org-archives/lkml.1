Return-Path: <linux-kernel-owner+w=401wt.eu-S1764939AbYBVCX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764939AbYBVCX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 21:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbYBVCXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 21:23:47 -0500
Received: from khc.piap.pl ([195.187.100.11]:56727 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbYBVCXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 21:23:47 -0500
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Newall <davidn@davidnewall.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>
	<5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
	<20080221154951.GA28328@cs181133002.pp.htv.fi>
	<adahcg2awag.fsf@cisco.com>
	<20080221210124.GD28328@cs181133002.pp.htv.fi>
	<alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
	<m3tzk1q3rt.fsf@maximus.localdomain>
	<47BE2985.6020305@davidnewall.com>
	<20080222020615.GE27894@ZenIV.linux.org.uk>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 22 Feb 2008 03:23:45 +0100
In-Reply-To: <20080222020615.GE27894@ZenIV.linux.org.uk> (Al Viro's message of "Fri\, 22 Feb 2008 02\:06\:15 +0000")
Message-ID: <m3myptsp8u.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> ... if your style is lousy.  I agree that situation with printks is
> not normal in that respect and I certainly have no love for the
> checkpatch nonsense, but pressure to keep the fucking nesting depth
> low is a Good Thing(tm).

Indeed. Unfortunately it is orthogonal to the line length limit.

We should limit the nesting level, though I think there is no
universally good value. What is good for one case (a function with a
short multi-level if/for/etc) is bad for another (a long switch()
where any added complexity makes it unparseable).

So I think it just have to meet the author's and reviewers' taste. We
already depend on this.
-- 
Krzysztof Halasa
