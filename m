Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbZKXFZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbZKXFZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 00:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZKXFZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 00:25:50 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51871 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbZKXFZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 00:25:49 -0500
Date: Tue, 24 Nov 2009 10:55:43 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v5 0/4] pseries: Add cede support for cpu-offline
Message-ID: <20091124052543.GA28097@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20091030052106.25493.42109.stgit@sofia.in.ibm.com>
 <1259033709.16367.110.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1259033709.16367.110.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt <benh@kernel.crashing.org> [2009-11-24 14:35:09]:

> On Fri, 2009-10-30 at 10:52 +0530, Gautham R Shenoy wrote:
> > Hi,
> > 
> > This is version 5 of patch series that provides a framework to choose the
> > state a pseries CPU must be put to when it is offlined.
> > 
> > Previous versions can be found here:
> > Version 4: http://lkml.org/lkml/2009/10/9/59
> > Version 3: http://lkml.org/lkml/2009/9/15/164
> > Version 2: http://lkml.org/lkml/2009/8/28/102
> > Version 1: http://lkml.org/lkml/2009/8/6/236
> > 
> > Changes from the previous version include:
> > - Rebased against Nathan Fontenot's latest "pseries kernel handling of dynamic
> >   logical paritioning v4" patches found here:
> >   http://lkml.org/lkml/2009/10/21/98
> 
> I can't merge them right now because afaik, Nathan patches are still not
> quite ready. So we need to either get a final version of Nathan patches
> something like tomorrow or you need to rebase your series on current
> -next by the end of the week, or I'm afraid it's going to miss the next
> merge window.

Hi Ben,

I had checked with Nathan earlier and he mentioned that he is working
on an update.  We can post a rebase to -next tomorrow, but this series
depends on Nathan's patch, hence will work with him. This feature is
important for the next merge window.

Thanks,
Vaidy
