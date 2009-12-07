Return-Path: <linux-kernel-owner+w=401wt.eu-S1751830AbZLGFbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbZLGFbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 00:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZLGFb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 00:31:29 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64407 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbZLGFb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 00:31:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wzjRvZM/dxHj3yJGs5lRH+dPXgP6iI+kqwxySiDEhukTvLlSOAAUODLl/Z0GW6b6xY
         hxi/wN77C6sStrzSU3SAImzO/RAbibhe8dNDIS4LX6MuN+IngIfxE9wnROJkIGesAlyT
         sTdWpZXLE9QQoojjnpRKPl/udKgc8HfYTAXMg=
Date: Mon, 7 Dec 2009 06:31:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2] perf: Make location of kernel source configurable
Message-ID: <20091207053131.GC5262@nowhere>
References: <20091206307.542816612@firstfloor.org> <20091207013339.GC4966@nowhere> <20091207052521.GA21422@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207052521.GA21422@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 06:25:21AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Sun, Dec 06, 2009 at 03:07:30PM +0100, Andi Kleen wrote:
> > > 
> > > tools/perf has no support for separate object directories
> > > and lots of hard coded paths assuming that the kernel source
> > > is always in ../..
> > > 
> > > As a first step of compiling it separately without messing
> > > up clean source trees allow to configure the kernel source
> > > location using a KERNELSRC variable 
> > > 
> > > This allows at least to copy the whole tools/perf
> > > directory elsewhere and build it separately.
> > > 
> > > The default is still ../.., so for a standard build
> > > nothing changes
> > > 
> > > This also removes a lot of ugly ../.. from the source.
> > > 
> > > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > 
> > 
> > It worry about that too.
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Frederic, mind queueing Andi's fix up in your tree and testing it there, 
> before pushing it to me via the regular route?
> 
> Thanks,
> 
> 	Ingo


Sure.

