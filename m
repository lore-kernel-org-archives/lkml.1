Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZKHSDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZKHSDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 13:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZKHSDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 13:03:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49954 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbZKHSDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 13:03:46 -0500
Date: Sun, 8 Nov 2009 19:03:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yinghai@kernel.org>, x86team <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86,apic: Use PAGE_SIZE instead of numbers
Message-ID: <20091108180335.GA17985@elte.hu>
References: <20091108155356.GB25940@lenovo>
 <alpine.LFD.2.00.0911081726350.9725@eddie.linux-mips.org>
 <20091108173650.GF25940@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108173650.GF25940@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Maciej W. Rozycki - Sun, Nov 08, 2009 at 05:28:05PM +0000]
> | On Sun, 8 Nov 2009, Cyrill Gorcunov wrote:
> | 
> | > The whole page is reserved for IO-APIC fixmap
> | > due to non-cacheable requirement. So lets note
> | > this explicitly instead of playing with numbers.
> | > 
> | > CC: Yinghai Lu <yinghai@kernel.org>
> | > CC: "Maciej W. Rozycki" <macro@linux-mips.org>
> | > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> | > ---
> | 
> | Acked-by: Maciej W. Rozycki <macro@linux-mips.org>
> | 
> |  Is PAGE_SIZE still always 4kB for the x86 these days?  If so, then your 
> | change makes sense to me.
> 
> Yeah, as far as I know. I didn't find any sign if we going to change 
> PAGE_SHIFT.

Not in the next 10-20 years or so. (and any prediction beyond that is 
pointless i suspect)

	Ingo
