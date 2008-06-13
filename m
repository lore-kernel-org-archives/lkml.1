Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbYFMKfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbYFMKfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 06:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbYFMKex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 06:34:53 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:38844 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753092AbYFMKew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 06:34:52 -0400
X-Greylist: delayed 1111 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jun 2008 06:34:52 EDT
Date: Fri, 13 Jun 2008 11:15:40 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] cputopology: Always define CPU topology information [5th try]
Message-ID: <20080613101539.GV11300@solarflare.com>
References: <20080604154454.GD11300@solarflare.com> <20080604214715.bbebe325.akpm@linux-foundation.org> <20080605120829.GI11300@solarflare.com> <20080605092831.a77d164d.akpm@linux-foundation.org> <20080605163714.GO11300@solarflare.com> <20080613051654.GC21586@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613051654.GC21586@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * Ben Hutchings <bhutchings@solarflare.com> wrote:
> 
> > Not all architectures and configurations define CPU topology 
> > information. This can result in an empty topology directory in sysfs, 
> > and requires in-kernel users to protect all uses with #ifdef - see 
> > <http://marc.info/?l=linux-netdev&m=120639033904472&w=2>.
> > 
> > The documentation of CPU topology specifies what the defaults should 
> > be if only partial information is available from the hardware.  So we 
> > can provide these defaults as a fallback.
> > 
> > This patch:
> > 
> > - Adds default definitions of the 4 topology macros to <linux/topology.h>
> > - Changes drivers/base/topology.c to use the topology macros unconditionally
> > - Updates documentation accordingly
> 
> applied to tip/core/topology - thanks Ben.

Unfortunately you lost the first paragraph of the commit message, then
created a second commit (difference between 4th and 5th versions) with
your own commit message and me as the author.  Maybe it's nitpicking but I
would prefer to have strictly accurate metadata in the commit log.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
