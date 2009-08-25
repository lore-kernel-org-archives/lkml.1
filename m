Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbZHYVba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbZHYVba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 17:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZHYVb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 17:31:29 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:53304 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbZHYVb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 17:31:28 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [Bug #13947] Libertas: Association request to the driver failed
Date: Tue, 25 Aug 2009 17:31:14 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc7; KDE/4.2.4; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, roel kluin <roel.kluin@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Daniel Mack <daniel@caiaq.de>,
       "John W. Linville" <linville@tuxdriver.com>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
 <200908211209.30493.gene.heskett@verizon.net>
 <1251231131.28331.2.camel@localhost.localdomain>
In-reply-to: <1251231131.28331.2.camel@localhost.localdomain>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-6
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200908251731.14385.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 August 2009, Dan Williams wrote:
>On Fri, 2009-08-21 at 12:09 -0400, Gene Heskett wrote:
>> On Friday 21 August 2009, Dan Williams wrote:
>> >On Thu, 2009-08-20 at 11:17 -0400, Gene Heskett wrote:
>> >> On Thursday 20 August 2009, Rafael J. Wysocki wrote:
>> >> >On Thursday 20 August 2009, roel kluin wrote:
>> >> >> > Bug-Entry       :
>> >> >> > http://bugzilla.kernel.org/show_bug.cgi?id=13947 Subject        
>> >> >> > : Libertas: Association request to the driver failed Submitter   
>> >> >> >    : Daniel Mack <daniel@caiaq.de>
>> >> >> > Date            : 2009-08-07 19:11 (13 days old)
>> >> >> > First-Bad-Commit:
>> >> >> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;
>> >> >> >a=c omm it;h=57921c312e8cef72ba35a4cfe870b376da0b1b87 References  
>> >> >> >    : http://marc.info/?l=linux-kernel&m=124967234311481&w=4
>> >> >> > Handled-By
>> >> >> >
>> >> >> > : Roel Kluin <roel.kluin@gmail.com>
>> >> >>
>> >> >> I think this should be fixed with patch of Dan Williams found here:
>> >> >>
>> >> >> http://lkml.org/lkml/2009/8/12/299
>> >> >
>> >> >Thanks, bug entry updated.
>> >>
>> >> Has this made it into 2.6.31-rc6?  I have one of these pci cards, and
>> >> it is still a no-show even after modprobing the mwl* and libertas
>> >> modules.
>> >
>> >You're still looking for the softmac stuff, which the 'libertas' driver
>> >doesn't support.  You want to keep track of mwl8k where any new support
>> >for softmac Marvell cards would end up.
>> >
>> >Dan
>>
>> I am also loading that mwl8k module, Dan, and that isn't doing any
>> notable good either.  These are NetGears latest pci 802-11bg cards.  And
>> the only pci or pci-e cards widely available (Staples stocks them) unless
>> wallmart might have some (spitui) Belkin cards.  I have not noted them at
>> my local wally's.
>
>Right, because mwl8k supports only the softmac 8687 PCI-E parts right
>now.  It doesn't yet support the 8335 or 8310 or 86xx TopDog parts yet.
>There hasn't been any movement on those for a while and I haven't gotten
>around to abstracting mwl8k's hardware support to handle the older
>parts.  But mwl8k is the only driver that could possibly be relevant for
>you, since libertas will always be for the fullmac-only parts (8385,
>8388, 8686, 8688).
>
>Dan

Thanks Dan, now I have a clearer picture, and I should be watching for 
patches to mwl8k to go by & testing them, that I can do if you want to put me 
on your patch list for that, if & when there are patches to test. ;-)

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

Bowie's Theorem:
	If an experiment works, you must be using the wrong equipment.

