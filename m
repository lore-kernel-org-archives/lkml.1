Return-Path: <linux-kernel-owner+w=401wt.eu-S1759828AbXGCP0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828AbXGCP0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbXGCP03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:26:29 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:60041 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbXGCP03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:26:29 -0400
To: Florian Attenberger <valdyn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca>
	<20070703135949.GB19565@master.home>
	<87hcol7en2.fsf@pelargir.dolphinics.no>
	<20070703150210.GA31495@master.home>
From: Arne Georg Gleditsch <argggh@dolphinics.no>
Date: Tue, 03 Jul 2007 17:26:27 +0200
In-Reply-To: <20070703150210.GA31495@master.home> (Florian Attenberger's message of "Tue\, 3 Jul 2007 17\:02\:10 +0200")
Message-ID: <87d4z97bks.fsf@pelargir.dolphinics.no>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Attenberger <valdyn@gmail.com> writes:
> yep, controlled by ntpd.
> You're right according to
> ftp://hpiers.obspm.fr/iers/bul/bulc/bulletinc.33
> that event shouldn't have been there.

I'm not all that versed in ntp-ish, but it appears that the leap
second insertion should be propagated through the ntp protocol.
Whether the leap second in question came from a ntp server giving out
wrong data or from a misinterpretation or bug in ntpd is of course
hard to say, but either way turning the clock back is unlikely to
reconstruct the circumstances.  An interesting exercise might be to
code up a small program to call adjtimex with timex.status |= STA_INS,
to see if this can trigger the problem.  (The bogus leap second might
be a red herring entirely, of course...)

-- 
								Arne.
