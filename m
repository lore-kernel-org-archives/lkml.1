Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbXENUtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbXENUtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbXENUsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:48:54 -0400
Received: from gw.goop.org ([64.81.55.164]:40683 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588AbXENUsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:48:54 -0400
Message-ID: <4648CB33.3060407@goop.org>
Date: Mon, 14 May 2007 13:48:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com>	<46489818.4000408@goop.org>	<20070514125946.0f74221c.akpm@linux-foundation.org>	<4648C062.5090704@goop.org> <20070514133745.5bfc34ac.akpm@linux-foundation.org>
In-Reply-To: <20070514133745.5bfc34ac.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Confused.  This patch conflicts a lot with James's one (which I named
> voyager-fix-build-broken-by-shift-to-smp_ops.patch).
>
> If your "i386: move common parts of smp into their own file" also fixes
> Voyager and is preferred then cool, but a) the changelog should tell us
> that and b) could James please test it?
>   

The first version of the patch did both, which I guess is the one you've
got.  The one I just sent has no Voyager pieces, and has a
Voyager-specific companion patch, which is the basis of the one that
James posted (with pieces of this patch pasted into it).

    J
