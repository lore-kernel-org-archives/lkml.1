Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbYKGIRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbYKGIRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 03:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYKGIRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 03:17:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:17299 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYKGIRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 03:17:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tqXlbUtiuavuMttyz9zh4sEkhvO21BcJKvRvXNrkieoSdNKelnsJ9/iBAdBwQjb+Fk
         OegbfzChVaJQRrGoT6kHyeroYK2Uzb/2f19ZfLYtypngYgPDzYGggaioskFmr9E2SeiJ
         sQKy+xbCFLCz0153kEtkiQcTFC4GJu93hZ7Ws=
Date: Fri, 7 Nov 2008 11:20:03 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ken Chen <kenchen@google.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081107082003.GA15800@x200.localdomain>
References: <20081106203520.GD3578@elte.hu> <20081107003021.GA18666@google.com> <20081107004824.GA28780@x200.localdomain> <20081107074147.GA26607@elte.hu> <20081107075925.GA1825@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107075925.GA1825@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 08:59:25AM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > > + * buffer size used for proc read.  See proc_info_read().
> > > > + * 4K page size but our output routines use some slack for overruns
> > > > + */
> > > > +#define PROC_BLOCK_SIZE	(3*1024)
> > 
> > That sounds like a proper limit - the hard limit for this particular 
> > printout function is 4096-170, so we are well within the 
> > PROC_BLOCK_SIZE range.
> 
> ok, i've added Ken's patch to tip/core/stacktrace and started testing 
> it.
> 
> Alexey, i've added your Acked-by because you appeared to like the 
> patch - let me know if i should remove it.

Of course, I don't like it!

Switch to seqfiles, add entry in TID table as well.

The idea is good, though.
