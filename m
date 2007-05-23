Return-Path: <linux-kernel-owner+w=401wt.eu-S934267AbXEWTca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934267AbXEWTca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbXEWTcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:32:20 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757447AbXEWTcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:32:19 -0400
Date: Wed, 23 May 2007 12:31:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, clameter@sgi.com,
       rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [PATCH 1/2] Define new percpu interface for shared data --
 version 3
Message-Id: <20070523123153.c4f8c7e6.akpm@linux-foundation.org>
In-Reply-To: <20070523192005.GB4072@localhost.localdomain>
References: <20070523185748.GA4072@localhost.localdomain>
	<79E93560F4A5FD42BB769DAAF8BEF62A01AA8CF8@scsmsx411.amr.corp.intel.com>
	<20070523192005.GB4072@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 12:20:05 -0700 Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> On Wed, May 23, 2007 at 12:09:56PM -0700, Yu, Fenghua wrote:
> > 
> > >Has there been any measurable benefit yet due to tail padding?
> > 
> > We don't have data that tail padding actually helps. It all
> > depends on what data the linker lays out in the cachelines.
> > 
> > As of now we just want to create the infrastructure (so that
> > more and more people who need it, can use it).
> 
> So what we have now is space wastage on some architectures, space savings on
> some, but with no measurable performance benefit due to the infrastructure
> itself.  Why not push the infrastructure when we really need it, as against
> pushing it now when we are not sure if it benefits?
> 

It makes sense from a theoretical POV and is pretty much a no-op in terms
of resource consumption.

The problem with the wait-until-it-hurts approach is that by the time
someone hurts from this and we find out about it, they may well be using
some year-old enterprise kernel and it's too late to fix it for them.

