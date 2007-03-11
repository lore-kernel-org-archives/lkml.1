Return-Path: <linux-kernel-owner+w=401wt.eu-S932806AbXCKDZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbXCKDZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 22:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbXCKDZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 22:25:16 -0500
Received: from mail31.syd.optusnet.com.au ([211.29.132.102]:46356 "EHLO
	mail31.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932806AbXCKDZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 22:25:15 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RSDL-mm 0.28
Date: Sun, 11 Mar 2007 14:59:28 +1100
User-Agent: KMail/1.9.5
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org, ck@vds.kolivas.org
References: <20070311013506.GD10459@waste.org> <8cd998d50703101828l71fbec7bi9a819ad7b7fd9828@mail.gmail.com> <20070310191614.5ac3cf4b.akpm@linux-foundation.org>
In-Reply-To: <20070310191614.5ac3cf4b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703111459.28806.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 March 2007 14:16, Andrew Morton wrote:
> > On Sun, 11 Mar 2007 13:28:22 +1100 "Con Kolivas" <kernel@kolivas.org>
> > wrote: Well... are you advocating we change sched_yield semantics to a
> > gentler form?
> >
> >From a practical POV: our present yield() behaviour is so truly awful that
>
> it's basically always a bug to use it.  This probably isn't a good thing.
>
> So yes, I do think that we should have a rethink and try to come up with
> behaviour which is more in accord with what application developers expect
> yield() to do.
>
> otoh,
>
> a) we should have done this five years ago.  Instead, we've spent that
>    time training userspace programmers to not use yield(), so perhaps
>    there's little to be gained in changing it now.
>
> b) if we _were_ to change yield(), people would use it more, and their
>    applications would of course suck bigtime when run on earlier 2.6
>    kernels.
>
>
> Bottom line: we've had a _lot_ of problems with the new yield() semantics.
> We effectively broke back-compatibility by changing its behaviour a lot,
> and we can't really turn around and blame application developers for that.

So... I would take it that's a yes for a recommendation with respect to 
implementing a new yield() ? A new scheduler is as good a time as any to do 
it.

-- 
-ck
