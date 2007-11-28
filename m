Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbXK1X56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbXK1X56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbXK1X5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:57:50 -0500
Received: from gw.goop.org ([64.81.55.164]:35889 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243AbXK1X5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:57:49 -0500
Message-ID: <474E007B.1020405@goop.org>
Date: Wed, 28 Nov 2007 15:57:47 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tobias Powalowski <t.powa@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Christoph Hellwig <hch@infradead.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] x86/paravirt: revert exports to restore old behaviour
References: <474CA0DA.3010005@goop.org> <20071128204050.GA29463@stusta.de> <474DDA7B.9090802@goop.org> <20071128223909.GE29463@stusta.de>
In-Reply-To: <20071128223909.GE29463@stusta.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This does not apply since we do not have a stable in-kernel API, and 
> therefore changes to the in-kernel API can by definition not be 
> regressions.
>
> 2.6.24 most likely contains hundreds of changes and removals of 
> in-kernel APIs that existed in 2.6.23.
>
> Are you seriously suggesting that e.g. every single change to any struct 
> under include/ [1] would require an announcement x kernel releases 
> before it can be implemented?

Well, no, but that's not the point.

You're not addressing the substance of this specific issue, which is
simply whether rdmsr/wrmsr and pmd_val/make_pmd are actually internal
interfaces that drivers have no business in using, or are they
legitimate interfaces?  If not, then what interface *should* drivers be
using to do these things?  They seem like perfectly reasonable things
for a driver to want to do, and I don't see any inherent problem with
these interfaces.

It's not like we need to curtail these interfaces for any technical
reason.  It's pretty much the arbitrary result of me choosing to type
"_GPL" rather than leaving it off.  Refusing to correct what amounts to
a typo seems petty.

    J
