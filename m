Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbYGXHAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbYGXHAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 03:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYGXHAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 03:00:24 -0400
Received: from dhcp-077-248-068-247.chello.nl ([77.248.68.247]:60895 "EHLO
	scorpion77.cjb.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYGXHAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 03:00:23 -0400
X-Greylist: delayed 1305 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jul 2008 03:00:23 EDT
Message-ID: <28993.213.197.214.77.1216881506.squirrel@scorpion77.cjb.net>
In-Reply-To: <20080723220107.3d26e30a@lxorguk.ukuu.org.uk>
References: <vi85j5-uig.ln1@scorpion77.cjb.net> <4880237A.7070002@kernel.org>
    <200807232219.47760.jeroen@scorpion77.cjb.net>
    <20080723220107.3d26e30a@lxorguk.ukuu.org.uk>
Date: Thu, 24 Jul 2008 08:38:26 +0200 (CEST)
Subject: Re: non functional pata dvd drive under 2.6.25.6
From: "Jeroen Beerstra" <jb@scorpion77.cjb.net>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Jeroen Beerstra" <jeroen@scorpion77.cjb.net>, "Tejun Heo" <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8-4.0.1.el4.XOS.1
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-AntiVirus-By: Clam Antivirus 0.92.1
X-AntiSpam-By: Spamassassin 3.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Wed, 23 Jul 2008 22:19:47 +0200
> Jeroen Beerstra <jeroen@scorpion77.cjb.net> wrote:
>
>> Hello Tejun,
>>
>> Op Friday 18 July 2008 07:00:42 schreef u:
>> > Hello, Jeroen.
>> >
>> > [cc'ing linux-ide]
>> >
>> > Hmmm... the problem could be caused by hald polling for media
>> presence.
>> >  Does "hal-disable-polling /dev/srX" make any difference?
>> > hal-disable-polling setting is persistent so if your drive goes
>> bonkers
>> > quickly after boot, you can disable polling, reboot and see whether
>> > anything is different.  Also, please post the result of "lspci -nn"
>> and
>> > "hdparm -I /dev/srX" && please try 2.6.26.
>> >
>> > Thanks.
>>
>> I'm pretty sure about that since the hald process I'm refering to points
>> to
>> the 'faulty' drive. However simply booting with noapic seems to fix all
>> of my
>> problems.
>
> There are lots of similar reports. I don't know what broke the APIC code
> but it doesn't appear any of these are libata bugs.
>
> Alan
>

As soon as I have my system back and running again I will test the patch
that was attached to the rh bugzilla report, perhaps that will make things
a bit clearer.

Jeroen
