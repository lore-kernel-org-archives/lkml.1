Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbYDDGMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbYDDGMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 02:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYDDGMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 02:12:41 -0400
Received: from nn7.de ([85.214.94.156]:49235 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbYDDGMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 02:12:39 -0400
Subject: Re: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n -
	Apple
From: Soeren Sonnenburg <kernel@nn7.de>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: "Carlos R\. Mafra" <crmafra2@gmail.com>,
       "Pallipadi\, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pallipadi@ogre.sisk.pl
In-Reply-To: <2c0942db0804032015y57e91811r37b729cd836cef6d@mail.gmail.com>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	 <pdYe6zNQVl.A.AOB.6GW9HB@albercik>
	 <924EFEDD5F540B4284297C4DC59F3DEED0EA1E@orsmsx423.amr.corp.intel.com>
	 <20080404011053.GA21254@localhost.ift.unesp.br>
	 <2c0942db0804032015y57e91811r37b729cd836cef6d@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 04 Apr 2008 08:05:55 +0200
Message-Id: <1207289155.4513.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-03 at 20:15 -0700, Ray Lee wrote:
> On Thu, Apr 3, 2008 at 6:10 PM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
> > On Thu  3.Apr'08 at 17:14:22 -0700, Pallipadi, Venkatesh wrote:
> >  > >The following report is on the current list of known regressions
> >  > >from 2.6.24.  Please verify if the issue is still present in the
> >  > >mainline.
> >  > >
> >  > >
> >  > >Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=10093
> >  > >Subject              : 2.6.25-current-git hangs on boot
> >  > >unless CONFIG_CPU_IDLE=n - Apple
> >  > >Submitter    : Soeren Sonnenburg <kernel@nn7.de>
> >  > >Date         : 2008-02-23 18:55 (41 days old)
> >  > >References   : http://lkml.org/lkml/2008/2/23/263
> >  > >
> >  > >http://marc.info/?l=linux-acpi&m=120387537018467&w=4
> >  > >Handled-By   : Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
> >  > >
> >  >
> >  > Last comment I saw from Soeren says it does not really hang. It waits
> >  > for 5-10 seconds sometimes before continuing. We are still trying to
> >  > narrow this down with max_cstate etc..
> >
> >  I should say that my laptop (Vaio) _hangs_ at boot (less than 10% of boots)
> >  and this is the last message I see:
> >
> >  "ACPI: Processor [CPU1] (supports 8 throttling states)"
> >
> >  and it stays there "forever" (more than 1 or 2 minutes at least).
> >
> >  I am not using my laptop too much these days, and I thought this
> >  bug had been solved because it didn't hang for the last week (but
> >  I boot it once per day), however it hang last night (using some
> >  post 2.6.25-rc7 kernel)
> >
> >  I have pictures of the screen while showing this last message at boot,
> >  should I post it somewhere or that is not necessary?.
> 
> If the sysrq key still works when that happens, try to do a sysrq-t,
> s, b to generate a trace, sync the filesystem, and reboot. If anything
> made it to the logs, please post it.

How could I potentially do that on this #^%^! apple keyboard?
Soeren
