Return-Path: <linux-kernel-owner+w=401wt.eu-S1161036AbXAaX0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161036AbXAaX0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161072AbXAaX0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:26:48 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:59620 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161036AbXAaX0s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:26:48 -0500
Date: Wed, 31 Jan 2007 23:26:41 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: x86 instability with 2.6.1{8,9}
Message-ID: <20070131232641.GA26331@deepthought>
References: <20070101160158.GA26547@deepthought> <200701021225.57708.lenb@kernel.org> <20070102180425.GA18680@deepthought> <200701021342.32195.lenb@kernel.org> <20070102193459.GA19894@deepthought> <20070106140459.a6b72039.randy.dunlap@oracle.com> <20070107142641.GA30379@deepthought> <20070115162911.GA13198@deepthought> <20070125235627.GA17168@deepthought> <45C10BDE.80801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <45C10BDE.80801@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 04:36:30PM -0500, Chuck Ebbert wrote:
> Ken Moffat wrote:
> > On Mon, Jan 15, 2007 at 04:29:11PM +0000, Ken Moffat wrote:
> >   
> >  Bizarre - it panic'd again last Thursday while I was in X, but I
> > still didn't manage to log any output.  At the weekend, I had the
> > bright idea of using chattr +j on the syslog to try to journal any
> > data, since then it has been fine.  So, it isn't down to highmem, and
> > I still can't trigger it reliably, or get any trace.  Tried running
> > as x86_64 this morning (because cold starts on Thursdays seem
> > particularly problematic, perhaps it's a time/power-supply-noise
> > problem), then x86 from a cold start this afternoon.
> >
> >  Time to hope it won't bite me too often, and move on to testing
> > 2.6.20-rc6.
> >
> > Ken
> >   
> Try disabling preempt.

 Thanks for the suggestion - any particular reason ?  That box is
running as 64-bit at the moment, and likely to stay that way for the
rest of this week while it builds userspace, but I'm not averse to
running 32-bit on it again if it serves a purpose.

 However, in the vain hope I can actually get it to log something,
wouldn't it be more useful to continue running _with_ preempt ?

 I'm starting to think it might have been yet another victim of the
solar flares, and the fact it was always running a 32-bit kernel
could have been coincidence.

Ken 
-- 
das eine Mal als Tragödie, das andere Mal als Farce
