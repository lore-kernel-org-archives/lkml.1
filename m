Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbZDGE0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbZDGE0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbZDGE0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:26:38 -0400
Received: from ozlabs.org ([203.10.76.45]:47555 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbZDGE0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:26:37 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: pm-hibernate : possible circular locking dependency detected
Date: Tue, 7 Apr 2009 13:56:28 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ming Lei <tom.leiming@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <d82e647a0904050253n31bd2654s9b216465eec4d038@mail.gmail.com> <200904051212.53353.rjw@sisk.pl> <20090405134454.GB25250@elte.hu>
In-Reply-To: <20090405134454.GB25250@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904071356.29914.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 April 2009 23:14:54 Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Sunday 05 April 2009, Ming Lei wrote:
> > > kernel version : one simple usb-serial patch against  commit
> > > 6bb597507f9839b13498781e481f5458aea33620.
> > > 
> > > Thanks.
> > 
> > Hmm, CPU hotplug again, it seems.
> > 
> > I'm not sure who's the maintainer at the moment.  Andrew, is that 
> > Gautham?
> 
> CPU hotplug tends to land on the scheduler people's desk normally.
> 
> But i'm not sure that's the real thing here - key appears to be this 
> work_on_cpu() worklet by the cpufreq code:

Looks like this will be fixed by Andrew's work-on-cpu-in-own-thread
patch which I just put out the pull request for.

Cheers,
Rusty.
