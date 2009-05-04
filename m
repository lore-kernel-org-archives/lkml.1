Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbZEDKwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbZEDKwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 06:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZEDKwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 06:52:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:15379 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZEDKwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 06:52:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Cr3jq8AOOiCU04c6n43fHhNXOvPNNH6GCb+e9sVyYCh/gX3vnFFqwQSSMDiJZAFTtM
         bnhxfrU7sOx+vSM+NCYpzLyY6PXuSs+5UFyDVILcaKXUB1iMvLZheMVOnp/K25woZa1T
         nUoUynPAeJN/9YoAdrWfGb5TzAAvA18hcD9go=
Date: Mon, 4 May 2009 14:52:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: introducing __GFP_PANIC
Message-ID: <20090504105206.GF4173@lenovo>
References: <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com> <20090503204542.GJ4615@lenovo> <alpine.DEB.2.00.0905031357140.17811@chino.kir.corp.google.com> <20090504081454.GA4173@lenovo> <1241425941.21088.19.camel@penberg-laptop> <20090504090825.GC4173@lenovo> <1241431031.21088.21.camel@penberg-laptop> <20090504100106.GD4173@lenovo> <20090504101121.GE4173@lenovo> <1241433188.21088.22.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241433188.21088.22.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Mon, May 04, 2009 at 01:33:08PM +0300]
| On Mon, 2009-05-04 at 14:11 +0400, Cyrill Gorcunov wrote:
| > I believe this version should be correct (still RFC).
| > __GFP_NOWARN has printk limit so instead of making
| > additional checks (while combining those prink in
| > original code) just adding panic with order and flags
| > should be cleaner (as it done at moment :)
| 
| Looks good to me!
| 
| Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
| 
| I suspect the patch needs some additional work for -mm due to Mel
| Gorman's page allocator cleanup and optimization patches.
| 
| 			Pekka
| 

Thanks a lot, Pekka! I'll resend this one with Mel CC'ed so he
could take a look (and a couple of people I know involved in
memory management as well).

	-- Cyrill
