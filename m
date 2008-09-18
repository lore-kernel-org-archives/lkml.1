Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbYIRJYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbYIRJYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 05:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYIRJYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 05:24:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513AbYIRJY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 05:24:29 -0400
Date: Thu, 18 Sep 2008 02:23:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm 2008-09-13-03-09 uploaded
Message-Id: <20080918022353.dca4b5c3.akpm@linux-foundation.org>
In-Reply-To: <1221727868.6892.66.camel@odin>
References: <200809131011.m8DABTON031878@imap1.linux-foundation.org>
	<20080918150115.1aa45123.kamezawa.hiroyu@jp.fujitsu.com>
	<20080917232648.5b991958.akpm@linux-foundation.org>
	<1221727868.6892.66.camel@odin>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 09:51:08 +0100 Liam Girdwood <lrg@slimlogic.co.uk> wrote:

> On Wed, 2008-09-17 at 23:26 -0700, Andrew Morton wrote:
> > On Thu, 18 Sep 2008 15:01:15 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > On Sat, 13 Sep 2008 03:11:29 -0700
> > > akpm@linux-foundation.org wrote:
> > > 
> > > > The mm-of-the-moment snapshot 2008-09-13-03-09 has been uploaded to
> > > git-regulator.patch
> > > 
> > > I'm not so familiar with this HEAD: but is this from git ?
> > > 
> > > This change
> > > 
> > > --- a/drivers/regulator/Makefile
> > > +++ b/drivers/regulator/Makefile
> > > @@ -7,6 +7,9 @@ obj-$(CONFIG_REGULATOR) += core.o
> > >  obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
> > >  obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
> > > 
> > > +<<<<<<< HEAD:drivers/regulator/Makefile
> > >  obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
> > > 
> > > +=======
> > > +>>>>>>> FETCH_HEAD:drivers/regulator/Makefile
> > >  ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
> > > 
> > > 
> > > stops "make clean"
> > > ==
> > > [kamezawa@bluextal mmtom-2.6.26-rc6+]$ make clean
> > > /home/kamezawa/mmtom-2.6.26-rc6+/drivers/regulator/Makefile:13: *** empty variable name.  Stop.
> > > make[1]: *** [drivers/regulator] Error 2
> > > make: *** [_clean_drivers] Error 2
> > > 
> > > Hmm ? (at build, CONFIG_REGULATOR=n allows me to avoid this.)
> > > 
> > 
> > argh, sorry.
> > 
> > I pull git-regulator daily, check to see if it got fixed up yet and if
> > not, comment it out.  I apparently forgot to do the last two steps on
> > 2008-09-13-03-09.
> > 
> > I'll do 2008-09-17-XX-XX right now..
> 
> git-regulator has been upstream since rc2 so I'm surprised we are seeing
> this atm.

oic.  I'm pulling some dead old thing from
git://opensource.wolfsonmicro.com/linux-2.6-audioplus.git#for-akpm

> Can I just confirm the repository & branch you are pulling as I've
> recently left Wolfson and now work for myself (I will no longer have
> guaranteed access to the Wolfson git repositories). I've also moved
> regulator development over to kernel.org:-
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git #dev
> 

Please send that off to Stephen for linux-next inclusion.
