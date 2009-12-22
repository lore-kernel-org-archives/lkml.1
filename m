Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZLVQVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZLVQVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 11:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbZLVQVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 11:21:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59132 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbZLVQVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 11:21:15 -0500
Date: Tue, 22 Dec 2009 17:21:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
Message-ID: <20091222162110.GG10314@basil.fritz.box>
References: <4B2F9582.5000002@gmail.com> <4B2F978D.7010602@redhat.com> <4B2F9C85.7070202@gmail.com> <4B2FA42F.3070408@codemonkey.ws> <4B2FA655.6030205@gmail.com> <4B2FAE7B.9030005@codemonkey.ws> <4B2FB3F1.5080808@gmail.com> <4B300EF8.8010602@codemonkey.ws> <87637zdy9g.fsf@basil.nowhere.org> <4B30E654.40702@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B30E654.40702@codemonkey.ws>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So far, the only actual technical advantage I've seen is that vbus avoids 
> EOI exits.  

The technical advantage is that it's significantly faster today.

Maybe your proposed alternative is as fast, or maybe it's not. Who knows?

> We think we understand why vbus does better than the current userspace 
> virtio backend.  That's why we're building vhost-net.  It's not done yet, 
> but our expectation is that it will do just as well if not better.

That's the vapourware vs working code disconnect I mentioned. One side has hard
numbers&working code and the other has expectations. I usually find it sad when the
vapourware holds up the working code.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
