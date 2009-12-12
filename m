Return-Path: <linux-kernel-owner+w=401wt.eu-S1752349AbZLLGKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbZLLGKv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 01:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbZLLGKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 01:10:48 -0500
Received: from home.kolivas.org ([59.167.196.135]:48595 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbZLLGKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 01:10:47 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: BFS v0.311 CPU scheduler for 2.6.32
Date: Sat, 12 Dec 2009 17:10:44 +1100
User-Agent: KMail/1.12.1 (Linux/2.6.32-ck1; KDE/4.3.2; x86_64; ; )
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200912111124.18118.kernel@kolivas.org> <200912121300.54803.kernel@kolivas.org> <20091212055459.GC32739@1wt.eu>
In-Reply-To: <20091212055459.GC32739@1wt.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912121710.44216.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009 16:54:59 Willy Tarreau wrote:
> Hi Con,
> 
> On Sat, Dec 12, 2009 at 01:00:54PM +1100, Con Kolivas wrote:
> > > If you are not doing your unpaid kernel work for yourself and for
> > > people who recognize/use it then upstream maintainers not liking your
> > > changes should really be the least of your worries..
> >
> > Wait, this does not make sense. There's a cyclical flaw in this
> > reasoning. If I cared about their acknowledgment, I would make it
> > mainline mergeable and argue a case for it, which I do not want to do.
> >
> > I'm happy to make reasonable changes to the code consistent with what
> > people who use it want, but what exactly is the point of making it
> > mainline mergeable if it will not be merged?
> 
> Many people build their own kernels by :
>   1) applying a lot of patches on them (stable + features)
>   2) using machine-specific configs
> 
> You will get far more testers if they can use the same kernel and
> just play with their config files than if they have to patch/unpatch
> depending on what they need to have.
> 
> I personally would love to be able to add BFS into my kernels for
> testing purposes, comparison, and possibly to propose enhancements
> and fixes. But I don't want to *replace* mainline code.
> 
> Also, I like to have the same kernel sources used on my desktop,
> notebook, eeepc, and my bootable USB key. It is a lot easier to
> upgrade and a lot easier to spot bugs before they strike in sensible
> environments.

Thanks Willy. 

That's the first meaningful reason I've heard for it. I may have to consider 
it now. It still would be compile time limited so probably not quite what 
you're hoping for. I don't have the time and energy to do and maintain the 
whole plugsched crap for boottime selection all over again, and that adds 
overhead which goes against one of my prime objectives.

Regards,
-- 
-ck
