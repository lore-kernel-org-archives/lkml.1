Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbZBLEI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbZBLEI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 23:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbZBLEIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 23:08:37 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:52296 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbZBLEIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 23:08:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d8zHjjgXY8tFpEHWwDCXDF48ysCMBIoOPSzh0VyaVwoiHkdil0Lp+LQ3AEKg1BagaH
         tmQfBFfzVpJa7OjQgr69DsOhNAvTGkPNjFp6tx447KwM39Vur5zZc75QO0HPF7FjH6sm
         /8UFiihEqZc0ASGyLrr8Im6zsedSoQ42FiWf8=
Date: Thu, 12 Feb 2009 05:08:30 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/7][RFC] function graph tracer port to PowerPC
Message-ID: <20090212040829.GB4809@nowhere>
References: <20090212011051.265346435@goodmis.org> <20090212015503.GA4697@nowhere> <alpine.DEB.1.10.0902112116340.13595@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902112116340.13595@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 09:16:57PM -0500, Steven Rostedt wrote:
> 
> On Thu, 12 Feb 2009, Frederic Weisbecker wrote:
> 
> > On Wed, Feb 11, 2009 at 08:10:51PM -0500, Steven Rostedt wrote:
> > > 
> > > The following set of patches are RFC and not for inclusion
> > > (unless everyone is fine with them as is).
> > > 
> > > This is the port to PowerPC of the function graph tracer that was written
> > > by Frederic Weisbecker for the x86 architecture.  It is broken up
> > > into a series of logical steps.
> > > 
> > > 1) get generic code ready for other archs
> > > 2) get PowerPC 64-bit working with just static function tracing
> > > 3) get PowerPC 64-bit working with dynamic function tracing
> > > 4) get PowerPC 32-bit working with just static function tracing
> > > 5) get PowerPC 32-bit working with dynamic function tracing
> > > 
> > > (with some clean ups in between)
> > > 
> > 
> > 
> > Thanks a lot Steven!
> > I'm sad to not having a Power Pc to test it...
> 
> If you had a PowerPC, I doubt I would have been the one to port it ;-)


Especially since you already implemented ftrace on PowerPc :)
I will acquire an Arm board soon to adapt function graph on Arm...
 
> -- Steve
> 

