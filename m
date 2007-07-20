Return-Path: <linux-kernel-owner+w=401wt.eu-S1761421AbXGTA27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421AbXGTA27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758077AbXGTA2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:28:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758014AbXGTA2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:28:51 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch] slub crashes with recent -git
References: <20070719194234.GA27917@elte.hu>
	<alpine.LFD.0.999.0707191307220.27249@woody.linux-foundation.org>
	<alpine.LFD.0.999.0707191324020.27249@woody.linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 20 Jul 2007 03:23:50 +0200
In-Reply-To: <alpine.LFD.0.999.0707191324020.27249@woody.linux-foundation.org>
Message-ID: <p734pjzx3yx.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, 19 Jul 2007, Linus Torvalds wrote:
> > 
> > A better patch should be the appended. Does that work for you too?
> 
> Btw, I already committed this as obvious. 
> 
> I did the same for the SLAB __do_kmalloc() thing. Let's hope that that was 
> the extent of the damage.

My 32bit crashes seem to be gone with latest git head, both
for slab and for slub. Even the serial console seems to work again. 
Thanks

-Andi
