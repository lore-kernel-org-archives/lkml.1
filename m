Return-Path: <linux-kernel-owner+w=401wt.eu-S934266AbXCWBhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266AbXCWBhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 21:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422631AbXCWBhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 21:37:50 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:48980 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934271AbXCWBht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 21:37:49 -0400
Date: Fri, 23 Mar 2007 02:36:12 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sukadev@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Define CLONE_NEWPID flag
Message-ID: <20070323013612.GH12080@MAIL.13thfloor.at>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	sukadev@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
	Containers <containers@lists.osdl.org>,
	linux-kernel@vger.kernel.org
References: <20070321194103.GA29820@us.ibm.com> <20070321133938.bff535a3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321133938.bff535a3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 01:39:38PM -0700, Andrew Morton wrote:
> On Wed, 21 Mar 2007 12:41:03 -0700
> sukadev@us.ibm.com wrote:
> 
> > This was discussed on containers and we thought it would be useful
> > to reserve this flag.
> > ---
> > 
> > From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> > Subject: [PATCH] Define CLONE_NEWPID flag
> > 
> > Define CLONE_NEWPID flag that will be used to clone pid namespaces.
> > 
> > Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> > ---
> >  include/linux/sched.h |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > Index: lx26-21-rc3-mm2/include/linux/sched.h
> > ===================================================================
> > --- lx26-21-rc3-mm2.orig/include/linux/sched.h	2007-03-20 20:13:19.000000000 -0700
> > +++ lx26-21-rc3-mm2/include/linux/sched.h	2007-03-21 11:10:33.000000000 -0700
> > @@ -26,6 +26,7 @@
> >  #define CLONE_STOPPED		0x02000000	/* Start in stopped state */
> >  #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
> >  #define CLONE_NEWIPC		0x08000000	/* New ipcs */
> > +#define CLONE_NEWPID		0x10000000      /* New pid namespace */
> 
> Do we actually have any need to reserve it at this time?  
> I'd have thought that we could defer adding this until we 
> have some code in-kernel which uses it.

FWIW, I'm fine with the reservation, we won't get around
it for the pid space, so we can as well register it now
YMMV

best,
Herbert

> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
