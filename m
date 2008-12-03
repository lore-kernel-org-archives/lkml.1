Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbYLCLh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbYLCLh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 06:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYLCLht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 06:37:49 -0500
Received: from relay2.sgi.com ([192.48.179.30]:51987 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751351AbYLCLhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 06:37:48 -0500
Date: Wed, 3 Dec 2008 05:37:44 -0600
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: holt@sgi.com, linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       ptesarik@suse.cz, tee@sgi.com, peterz@infradead.org, mingo@elte.hu,
       linux-arch@vger.kernel.org
Subject: Re: [Patch V3 0/3] Enable irqs when waiting for rwlocks
Message-ID: <20081203113744.GE8970@sgi.com>
References: <20081104122405.046233722@attica.americas.sgi.com> <20081202161311.ae3376cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202161311.ae3376cb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's a bit regrettable to have different architectures behaving in
> different ways.  It would be interesting to toss an x86_64
> implementation into the grinder, see if it causes any problems, see if
> it produces any tangible benefits.  Then other architectures might
> follow.  Or not, depending on the results ;)

I personally expect SGI to work on this for x86_64 in the future.
Once we actually start testing systems with 128 and above cpus, I
would expect to see these performance issues needing to be addressed.
Until then, it is just a theoretical.

Thank you for your help,
Robin Holt
