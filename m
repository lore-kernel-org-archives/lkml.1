Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbYH1AOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbYH1AOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 20:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbYH1AOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 20:14:11 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:35542 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753391AbYH1AOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 20:14:09 -0400
Message-ID: <48B5ED2C.60602@snapgear.com>
Date: Thu, 28 Aug 2008 10:11:24 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Bernd Petrovitsch <bernd@firmix.at>, Parag Warudkar <parag.lkml@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <20080826183051.GB10925@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org> <20080826205916.GB11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org> <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com> <alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org> <f7848160808261758q7b84aab1m188c1ebb59304818@mail.gmail.com> <1219827609.30209.29.camel@spike.firmix.at> <f7848160808270556q54c36270ye6a465d2ca123cc@mail.gmail.com> <1219843032.30209.51.camel@spike.firmix.at> <20080827154805.GA25387@shareable.org>
In-Reply-To: <20080827154805.GA25387@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jamie Lokier wrote:
> Bernd Petrovitsch wrote:
>> If you "develop" an embedded system (which is partly system integration
>> of existing apps) to be installed in the field, you don't have that many
>> conceivable work loads compared to a desktop/server system. And you have
>> a fixed list of drivers and applications.
> 
> Hah!  Not in my line of embedded device.
> 
> 32MB no-MMU ARM boards which people run new things and attach new
> devices to rather often - without making new hardware.  Volume's too
> low per individual application to get new hardware designed and made.
> 
> I'm seriously thinking of forwarding porting the 4 year old firmware
> from 2.4.26 to 2.6.current, just to get new drivers and capabilities.
> Backporting is tedious, so's feeling wretchedly far from the mainline
> world.
> 
>> A usual approach is to run stress tests on several (or all)
>> subsystems/services/... in parallel and if the device survives it
>> functioning correctly, it is at least good enough.
> 
> Per application.
> 
> Some little devices run hundreds of different applications and
> customers expect to customise, script themselves, and attach different
> devices (over USB).  The next customer in the chain expects the bits
> you supplied to work in a variety of unexpected situations, even when
> you advise that it probably won't do that.
> 
> Much like desktop/server Linux, but on a small device where silly
> little things like 'create a process' are a stress for the dear little
> thing.
> 
> (My biggest lesson: insist on an MMU next time!)

But given you have hardware you can't change would you choose
to not run Linux, even with the limitations of non-MMU?

Hell no :-)

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
