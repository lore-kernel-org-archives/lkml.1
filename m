Return-Path: <linux-kernel-owner+w=401wt.eu-S933652AbXCMVgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652AbXCMVgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 17:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933664AbXCMVgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 17:36:14 -0400
Received: from gw.goop.org ([64.81.55.164]:57539 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933652AbXCMVgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 17:36:13 -0400
Message-ID: <45F7194B.5080705@goop.org>
Date: Tue, 13 Mar 2007 14:36:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: David Miller <davem@davemloft.net>, nickpiggin@yahoo.com.au,
       akpm@linux-foundation.org, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
References: <20070313200313.GG10459@waste.org> <45F706BC.7060407@goop.org> <20070313202125.GO10394@waste.org> <20070313.140722.72711732.davem@davemloft.net> <20070313211435.GP10394@waste.org>
In-Reply-To: <20070313211435.GP10394@waste.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> Well you -could- do this:
>
> - reuse a long in struct page as a used map that divides the page up
>   into 32 or 64 segments
> - every time you set a PTE, set the corresponding bit in the mask
> - when we zap, only visit the regions set in the mask
>
> Thus, you avoid visiting most of a PMD page in the sparse case,
> assuming PTEs aren't evenly spread across the PMD.
>
> This might not even be too horrible as the appropriate struct page
> should be in cache with the appropriate bits of the mm already locked,
> etc.
>   

And do the same in pte pages for actual mapped pages?  Or do you think
they would be too densely populated for it to be worthwhile?

    J

