Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbYDHL3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbYDHL3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662AbYDHLWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:22:36 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:54998 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbYDHLWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:22:35 -0400
Date: Tue, 8 Apr 2008 08:21:50 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Ken Moffat <zarniwhoop@ntlworld.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>,
       a.p.zijlstra@chello.nl, aneesh.kumar@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       skumar@linux.vnet.ibm.com
Subject: Re: Regression in gdm-2.18 since 2.6.24
Message-ID: <20080408112149.GA4326@localhost.ift.unesp.br>
References: <20080403191916.GA30864@deepthought> <20080404143701.GA13042@linux.vnet.ibm.com> <20080404153232.GC21753@deepthought> <20080405144042.GB24075@linux.vnet.ibm.com> <20080405210347.GA19097@deepthought> <20080406234833.GA12131@deepthought> <20080408085027.GB13042@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408085027.GB13042@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue  8.Apr'08 at 14:20:27 +0530, Srivatsa Vaddagiri wrote:
> On Mon, Apr 07, 2008 at 12:48:33AM +0100, Ken Moffat wrote:
> >  Well, I found your analysis convincing.  Unfortunately, my hardware
> > disagreed.  Testing -rc8 with CONFIG_GROUP_SCHED disabled (a test is
> > a mixture of 5 attempts to restart and 5 to shutdown):
> > 
> > 1. the base version success is 4/10
> > 
> > 2. increasing the granularity by a factor of 10 as you requested,
> > success is 8/10
> 
> This makes me think that we are just exposing a timing related problem
> in gdm here.

I can see the same issue in my desktop with kdm, but I've never had
the energy to bisect or look further into it, so I just type halt or
reboot in xterm :-(

But the fact is that a few days ago I tried rebooting through kdm button,
but it left me with a console login screen (and no reboot).

It also happened a few times before too (and I am always using a 
uptodated 2.6.25-rcX kernel).

