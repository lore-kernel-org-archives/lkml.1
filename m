Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZHUPd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZHUPd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 11:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZHUPdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 11:33:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229AbZHUPdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 11:33:54 -0400
Subject: Re: [Bug #13947] Libertas: Association request to the driver failed
From: Dan Williams <dcbw@redhat.com>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, roel kluin <roel.kluin@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Daniel Mack <daniel@caiaq.de>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200908201117.45678.gene.heskett@verizon.net>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
	 <25e057c00908200151i472fa3cem6da814e7115e1ea7@mail.gmail.com>
	 <200908201710.32147.rjw@sisk.pl>
	 <200908201117.45678.gene.heskett@verizon.net>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 10:33:36 -0500
Message-Id: <1250868816.2505.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 11:17 -0400, Gene Heskett wrote:
> On Thursday 20 August 2009, Rafael J. Wysocki wrote:
> >On Thursday 20 August 2009, roel kluin wrote:
> >> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13947
> >> > Subject         : Libertas: Association request to the driver failed
> >> > Submitter       : Daniel Mack <daniel@caiaq.de>
> >> > Date            : 2009-08-07 19:11 (13 days old)
> >> > First-Bad-Commit:
> >> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=comm
> >> >it;h=57921c312e8cef72ba35a4cfe870b376da0b1b87 References      :
> >> > http://marc.info/?l=linux-kernel&m=124967234311481&w=4 Handled-By     
> >> > : Roel Kluin <roel.kluin@gmail.com>
> >>
> >> I think this should be fixed with patch of Dan Williams found here:
> >>
> >> http://lkml.org/lkml/2009/8/12/299
> >
> >Thanks, bug entry updated.
> >
> Has this made it into 2.6.31-rc6?  I have one of these pci cards, and it is 
> still a no-show even after modprobing the mwl* and libertas modules.

You're still looking for the softmac stuff, which the 'libertas' driver
doesn't support.  You want to keep track of mwl8k where any new support
for softmac Marvell cards would end up.

Dan


