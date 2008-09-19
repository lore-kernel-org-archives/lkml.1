Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbYISKAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbYISKAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 06:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYISKAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 06:00:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:38687 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYISKAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 06:00:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ts8onAfwXkVnbiajiodpayv3b54VUn1ygpJ5tceMERz1smN/IsGhXoQAI7lh/qBJAo
         xjtWs2qZ6ZV2Bx++uPGQ01xuL6E32InbKkVNgVXXN0xd/HNUdFbJCFJy4N496PJop416
         jfXxsmxiaufE2i1wo0jxzow4r2ne0PhBqPEYU=
Date: Fri, 19 Sep 2008 14:00:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip/master] x86: io-apic - restore_IO_APIC_setup NULL
	pointer quick fix
Message-ID: <20080919100009.GC7222@lenovo>
References: <20080918193757.GB7294@lenovo> <20080919080520.GA19491@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919080520.GA19491@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Fri, Sep 19, 2008 at 10:05:20AM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > Check if memory was granted first - we don't like NULL deref.
| > It's a *quick* fix. Actually it's better to hadle this error
| > at moment of memory allocation. It's save_mask_IO_APIC_setup
| > route who allocates this memory (just for the record).
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > ---
| > 
| > I'll handle this in _normal_ way tomorrow. Please review.
| 
| ok, i've applied the quick fix to tip/master - the patch will drop from 
| there on the next integration run.
| 
| 	Ingo
| 

thanks Ingo, it seems there memory leak too. Handling...

		- Cyrill -
