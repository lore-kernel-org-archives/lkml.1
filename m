Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYGWA4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYGWA4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 20:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYGWA4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 20:56:48 -0400
Received: from ag-out-0708.google.com ([72.14.246.240]:54662 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYGWA4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 20:56:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=IfPuv6EQ+vDqS0nBwGUNiL0HoamdlEON73kODfDfi3WrpnknguF5sljDsxlpodkBdV
         4HUxC0tNLW19Tg5kLUmT6jmuaIqjdjEMYaHEJA62m2E7N0nlrorQSjacoBi9Fqyy5vsL
         fSksquUFT/gWc727gmxBWa5/SRr+yB3La1Lcw=
Date: Wed, 23 Jul 2008 03:55:08 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: penberg@cs.helsinki.fi, cl@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net, mpm@selenic.com
Subject: Re: [RFC PATCH 1/4] kmemtrace: Core implementation.
Message-ID: <20080723005508.GA5555@localhost>
References: <1216751493-13785-1-git-send-email-eduard.munteanu@linux360.ro> <1216751493-13785-2-git-send-email-eduard.munteanu@linux360.ro> <y0mvdyx7gnj.fsf@ton.toronto.redhat.com> <20080723005002.GA5206@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723005002.GA5206@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 03:50:02AM +0300, Eduard - Gabriel Munteanu wrote:
> On Tue, Jul 22, 2008 at 05:28:16PM -0400, Frank Ch. Eigler wrote:
> > 
> > Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> writes:
> > 
> > > kmemtrace provides tracing for slab allocator functions, such as kmalloc,
> > > kfree, kmem_cache_alloc, kmem_cache_free etc.. Collected data is then fed
> > > to the userspace application in order to analyse allocation hotspots,
> > > internal fragmentation and so on, making it possible to see how well an
> > > allocator performs, as well as debug and profile kernel code.
> > > [...]
> > 
> > It may make sense to mention in addition that this version of
> > kmemtrace uses markers as the low-level hook mechanism, and this makes
> > the data generated directly accessible to other tracing tools such as
> > systemtap.  Thank you!
> > 
> > 
> > - FChE
> 
> Sounds like a good idea, but I'd like to get rid of markers and use
> Mathieu Desnoyers' tracepoints instead. I'm just waiting for tracepoints
> to get closer to inclusion in mainline/-mm.
> 
> It would be great if tracepoints completely replaced markers, so SystemTap
> would use those instead.
> 
> However, if tracepoints are not ready when kmemtrace is to be merged,
> I'll take your advice and mention markers and SystemTap.
> 
> 
> 	Thanks,
> 	Eduard
>

(fixed Matt's Cc.)

