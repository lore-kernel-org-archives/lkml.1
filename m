Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbZKKVqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbZKKVqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759344AbZKKVqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:46:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759341AbZKKVqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:46:04 -0500
Subject: Re: [PATCH v5 0/4] pseries: Add cede support for cpu-offline
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@au1.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Nathan Fontenot <nfont@austin.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1257975350.2140.49.camel@pasglop>
References: <20091030052106.25493.42109.stgit@sofia.in.ibm.com>
	 <1257945935.4372.36.camel@twins>  <1257975350.2140.49.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Nov 2009 22:45:17 +0100
Message-ID: <1257975917.4039.82.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 08:35 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2009-11-11 at 14:25 +0100, Peter Zijlstra wrote:
> > On Fri, 2009-10-30 at 10:52 +0530, Gautham R Shenoy wrote:
> > 
> > > Gautham R Shenoy (4):
> > >       pseries: Serialize cpu hotplug operations during deactivate Vs deallocate
> > >       pseries: Add code to online/offline CPUs of a DLPAR node.
> > >       pSeries: Add hooks to put the CPU into an appropriate offline state
> > >       pSeries: extended_cede_processor() helper function.
> > > 
> > > 
> > >  Documentation/cpu-hotplug.txt                   |    6 +
> > >  arch/powerpc/include/asm/lppaca.h               |    9 +
> > >  arch/powerpc/platforms/pseries/dlpar.c          |  129 ++++++++++++++++
> > >  arch/powerpc/platforms/pseries/hotplug-cpu.c    |  182 ++++++++++++++++++++++-
> > >  arch/powerpc/platforms/pseries/offline_states.h |   18 ++
> > >  arch/powerpc/platforms/pseries/plpar_wrappers.h |   22 +++
> > >  arch/powerpc/platforms/pseries/smp.c            |   19 ++
> > >  arch/powerpc/xmon/xmon.c                        |    3 
> > >  drivers/base/cpu.c                              |    2 
> > >  include/linux/cpu.h                             |   13 ++
> > >  10 files changed, 387 insertions(+), 16 deletions(-)
> > >  create mode 100644 arch/powerpc/platforms/pseries/offline_states.h
> > 
> > Not quite sure how you solved the DLPAR communication but since pretty
> > much everything is under arch/powerpc/ I really don't have much to say.
> 
> Allright. I was hoping to have your ack for the drivers/base/cpu.c
> change :-)

Sure.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

