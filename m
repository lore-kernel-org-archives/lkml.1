Return-Path: <linux-kernel-owner+w=401wt.eu-S1765278AbXFEPlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765278AbXFEPlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761140AbXFEPlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:41:09 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:49294 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763311AbXFEPlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:41:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G44ETJ6n4MLyH0oUcujoBWs7YtOHcrSHmqQjXUvF1sBAJyuYSb4jL94ANcbESY9n3zucOhmAIIj7zAAzudn2ffpEnZSDHlohZFDKWVsMnfm5B/u31kqAo8fr8LjNMVfA1c4h31h+eMCowKh9VlyMWqIGGy/IH/iI+OsCuBAcP9U=
Message-ID: <b647ffbd0706050841v2a326fb4n128249131ccbc11a@mail.gmail.com>
Date: Tue, 5 Jun 2007 17:41:07 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: Interesting interaction between lguest and CFS
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <b647ffbd0706050814u1e145b82qdb344d475d9ffe93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070604173710.GR11166@waste.org> <20070604175436.GC30274@elte.hu>
	 <20070604184106.GG11115@waste.org> <20070605071904.GB25163@elte.hu>
	 <20070605140342.GR11115@waste.org>
	 <b647ffbd0706050814u1e145b82qdb344d475d9ffe93@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/07, Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> > now at 257428593818894 nsecs
> >
> > cpu: 0
> >   .nr_running            : 3
> >   .raw_weighted_load     : 2063
> >   .nr_switches           : 242830075
> >   .nr_load_updates       : 30172063
> >   .nr_uninterruptible    : 0
> >   .jiffies               : 64282148
> >   .next_balance          : 0
> >   .curr->pid             : 27182
> >   .clock                 : 125650217819008823
> >   .prev_clock_raw        : 257428516403535
>
> The delta (clock - prev_clock_raw) looks insane.
>

err.. please ignore it. 'clock' and 'prev_clock_raw' follow each other
only as long as the 'clock_warps' == 0.. otherwise 'delta' just
doesn't make any sense. And in your case:

  .clock_warps           : 9


-- 
Best regards,
Dmitry Adamushko
