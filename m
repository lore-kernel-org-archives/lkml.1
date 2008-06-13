Return-Path: <linux-kernel-owner+w=401wt.eu-S1760320AbYFMPhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760320AbYFMPhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 11:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbYFMPhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 11:37:06 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:39251 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756421AbYFMPhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 11:37:05 -0400
Date: Fri, 13 Jun 2008 16:36:37 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] cputopology: Always define CPU topology information [5th try]
Message-ID: <20080613153635.GY11300@solarflare.com>
References: <20080604154454.GD11300@solarflare.com> <20080604214715.bbebe325.akpm@linux-foundation.org> <20080605120829.GI11300@solarflare.com> <20080605092831.a77d164d.akpm@linux-foundation.org> <20080605163714.GO11300@solarflare.com> <20080613051654.GC21586@elte.hu> <20080613101539.GV11300@solarflare.com> <20080613110236.GA9867@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613110236.GA9867@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * Ben Hutchings <bhutchings@solarflare.com> wrote:
> 
> > > > This patch:
> > > > 
> > > > - Adds default definitions of the 4 topology macros to <linux/topology.h>
> > > > - Changes drivers/base/topology.c to use the topology macros unconditionally
> > > > - Updates documentation accordingly
> > > 
> > > applied to tip/core/topology - thanks Ben.
> > 
> > Unfortunately you lost the first paragraph of the commit message, then 
> > created a second commit (difference between 4th and 5th versions) with 
> > your own commit message and me as the author.  Maybe it's nitpicking 
> > but I would prefer to have strictly accurate metadata in the commit 
> > log.
> 
> that's OK, see the delta patch below, it's rather trivial. It's better 
> to do these small delta patches where each change stands on its own than 
> to review a more complex combo patch. (Suggest me any other commit 
> metadata for this delta if you prefer, we can still change it.)
[...]
 
The message should be:

Revert first two hunks of "cputopology: Always define CPU topology information"
which were redundant with "x86: cleanup early per cpu variables/accesses v4".

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
