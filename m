Return-Path: <linux-kernel-owner+w=401wt.eu-S1759464AbYFEQ32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbYFEQ32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbYFEQ3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:29:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764AbYFEQ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:29:20 -0400
Date: Thu, 5 Jun 2008 09:28:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] cputopology: Always define CPU topology information
 [4th try]
Message-Id: <20080605092831.a77d164d.akpm@linux-foundation.org>
In-Reply-To: <20080605120829.GI11300@solarflare.com>
References: <20080604154454.GD11300@solarflare.com>
	<20080604214715.bbebe325.akpm@linux-foundation.org>
	<20080605120829.GI11300@solarflare.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008 13:08:30 +0100 Ben Hutchings <bhutchings@solarflare.com> wrote:

> Andrew Morton wrote:
> > On Wed, 4 Jun 2008 16:44:56 +0100 Ben Hutchings <bhutchings@solarflare.com> wrote:
> > 
> > > Not all architectures and configurations define CPU topology information.
> > > This can result in an empty topology directory in sysfs, and requires
> > > in-kernel users to protect all uses with #ifdef - see
> > > <http://marc.info/?l=linux-netdev&m=120639033904472&w=2>.
> > > 
> > > The documentation of CPU topology specifies what the defaults should be
> > > if only partial information is available from the hardware.  So we can
> > > provide these defaults as a fallback.
> > > 
> > > This patch:
> > > 
> > > - Adds default definitions of the 4 topology macros to <linux/topology.h>
> > > - Changes drivers/base/topology.c to use the topology macros unconditionally
> > >   and to cope with definitions that aren't lvalues
> > > - Updates documentation accordingly
> > 
> > See, this is what I meant.  After your patch we have:
> [...]
> 
> Sorry, I don't know how that escaped me.  My changes to the show functions
> should be unnecessary - though I think that the two different implementations
> for lvalues and rvalues are a premature optimisation.

um, what does this mean.  Will you be sending an updated patch or should
I drop those two or...?

