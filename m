Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbYEYSV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbYEYSV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbYEYSVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:21:52 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:60941 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbYEYSVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:21:51 -0400
Date: Sun, 25 May 2008 21:19:15 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #10710] [BISECTED] Lots of "rescheduling IPIs" in powertop
Message-ID: <20080525181914.GH1791@cs181133002.pp.htv.fi>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik> <TW_YzGo9TFP.A.6XE.5eIOIB@albercik> <19f34abd0805241435o47b55292p49f3bcbe7037b8a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19f34abd0805241435o47b55292p49f3bcbe7037b8a5@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 11:35:29PM +0200, Vegard Nossum wrote:
> On Sat, May 24, 2008 at 10:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10710
> > Subject         : [BISECTED] Lots of "rescheduling IPIs" in powertop
> > Submitter       : Vegard Nossum <vegard.nossum@gmail.com>
> > Date            : 2008-05-13 20:42 (12 days old)
> > References      : http://marc.info/?l=linux-kernel&amp;m=121071176205864&amp;w=4
> >                  http://lkml.org/lkml/2008/5/18/120
> > Handled-By      : Andi Kleen <andi@firstfloor.org>
> >                  Arjan van de Ven <arjan@infradead.org>
> >                  Ingo Molnar <mingo@elte.hu>
> > Patch           : http://marc.info/?l=linux-kernel&amp;m=121074826823352&amp;w=4
> 
> It has been fixed in mainline and should not still be listed:
> 
> commit a738d897b7b03b83488ae74a9bc03d26a2875dc6
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed May 14 08:47:40 2008 +0200
> 
>     x86: remove mwait capability C-state check
> 
> Thanks :-D

Thanks, closed.

> Vegard

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

