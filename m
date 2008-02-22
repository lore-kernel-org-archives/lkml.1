Return-Path: <linux-kernel-owner+w=401wt.eu-S935890AbYBVW3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935890AbYBVW3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbYBVW3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:29:06 -0500
Received: from khc.piap.pl ([195.187.100.11]:53696 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722AbYBVW3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:29:03 -0500
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
	<m3myptsp8u.fsf@maximus.localdomain>
	<20080222031315.GF27894@ZenIV.linux.org.uk>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 22 Feb 2008 23:28:58 +0100
In-Reply-To: <20080222031315.GF27894@ZenIV.linux.org.uk> (Al Viro's message of "Fri\, 22 Feb 2008 03\:13\:15 +0000")
Message-ID: <m38x1c4od1.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> IMO the line length overruns make good warnings.  Not as in "here's a cheap
> way to get more changesets", but as in "that code might have other problems
> nearby" kind of heuristics.

Sure, it does. However the human looking at the code is far better at
spotting such problems. Machine-generated warnings are great when the
machine is actually better than human.

Anyway, warnings are one thing and line limit is another. We may raise
the limit leaving the 80-chars warning in place. Unless there are too
many false positives, of course.
-- 
Krzysztof Halasa
