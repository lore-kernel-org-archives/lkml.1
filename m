Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbYBVG3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbYBVG3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 01:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYBVG3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 01:29:41 -0500
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:43236 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYBVG3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 01:29:40 -0500
From: Junio C Hamano <junio@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ofa-general] Re: Merging of completely unreviewed drivers
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>
 <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
 <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com>
 <20080221210124.GD28328@cs181133002.pp.htv.fi>
 <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
 <m3tzk1q3rt.fsf@maximus.localdomain> <47BE2985.6020305@davidnewall.com>
 <20080222020615.GE27894@ZenIV.linux.org.uk>
 <alpine.LFD.1.00.0802211858140.19896@woody.linux-foundation.org>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       David Newall <davidn@davidnewall.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Roland Dreier <rdreier@cisco.com>, Faisal Latif <flatif@NetEffect.com>
Date: Thu, 21 Feb 2008 22:29:09 -0800
In-Reply-To: <alpine.LFD.1.00.0802211858140.19896@woody.linux-foundation.org>
 (Linus Torvalds's message of "Thu, 21 Feb 2008 19:13:19 -0800 (PST)")
Message-ID: <7vbq69pkqy.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> So I'd be happier with warnings about deep indentation (but how do you 
> count it? Will people then try to fake things out by using 4-space indents 
> and then "deep" indentations will look like just a couple of tabs?) and 
> against complex expressions (ie "if ((a = xyz()) == NULL) .." should just 
> be split up into "a = xyz(); if (!a) ..", but there are sometimes reasons 
> for those things too!

Deep indentation should be fairly easy, given that you
already have rules in place that says "Tabs are 8 characters".
So if you find a line that begins with more than say 4 SP, you
can flag that as already bogus (i.e. "does not indent with HT"),
more than 8 SP definitely so.

I'll leave harder "complex expressions" to sparse experts ;-),

