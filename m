Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbYFDPIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbYFDPIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758371AbYFDPIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:08:15 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:45899 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758121AbYFDPIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:08:13 -0400
Date: Wed, 4 Jun 2008 16:07:07 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] cputopology: Add default CPU topology information [3rd try]
Message-ID: <20080604150705.GC11300@solarflare.com>
References: <20080531214429.GQ1743@solarflare.com> <20080603130222.694c5675.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603130222.694c5675.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 31 May 2008 22:44:30 +0100
> Ben Hutchings <bhutchings@solarflare.com> wrote:
> 
> > Define the macros topology_{physical_package,core}_id() and
> > topology_{thread,core}_siblings() in <asm-generic/topology.h> if they are not
> > already defined.
> > 
> > Move inclusion of <asm-generic/topology.h> after definitions of these
> > macros in <asm-powerpc/topology.h> and <asm-x86/topology.h>.
> > 
> > Change drivers/base/topology.c to use the topology macros unconditionally and
> > to cope with definitions that aren't lvalues.
> 
> Can you please redo this against linux-next?

Will do.

> That tree contains a number of directly conflicting changes.  In
> particular, linux-next introduces alternate implementations of
> show_##name and show_##name##_list in topology.c and from a quick peek,
> your change could make them go away again.

I don't see what you're referring to.  The only things I'm removing are
the attribute list macros, which are unnecessary if the list of attributes
is constant.

> Please also enhance the changelog so we have some idea of why you're
> actually doing all this.  What do we gain?  Does it fix a bug?  If so,
> what?  etc.

I'll go back to the explanatory text from my first version.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
