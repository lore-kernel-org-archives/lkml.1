Return-Path: <linux-kernel-owner+w=401wt.eu-S936162AbYEBVoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936162AbYEBVoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 17:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbYEBVoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 17:44:04 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:49092 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337AbYEBVoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 17:44:02 -0400
Subject: Re: Sharing disks amoung multiple software RAIDs
From: Kasper Sandberg <lkml@metanurb.dk>
To: David Greaves <david@dgreaves.com>
Cc: David Rees <drees76@gmail.com>, David Lethe <david@santools.com>,
       alex14641@yahoo.com, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <481AD006.6050708@dgreaves.com>
References: <1209692359.16523.2.camel@localhost>
	 <73000.21239.qm@web50212.mail.re2.yahoo.com>
	 <A20315AE59B5C34585629E258D76A97C335477@34093-C3-EVS3.exchange.rackspace.com>
	 <1209696179.16523.13.camel@localhost>
	 <72dbd3150805020006p7f976a04o487389840f03b4a2@mail.gmail.com>
	 <1209715763.7827.2.camel@localhost>  <481AD006.6050708@dgreaves.com>
Content-Type: text/plain; charset=ISO-8859-15
Date: Fri, 02 May 2008 23:43:50 +0200
Message-Id: <1209764630.7827.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 09:25 +0100, David Greaves wrote:
> Kasper Sandberg wrote:
> > Im not treating it as a backup, what i want, is to make sure that if 1
> > disk dies, the data is still intact and ill hopefully be able to run
> > with 1 disk till the newly ordered one arrives
> Probably one of the main design objectives behind RAID/md

Exactly, but once people start saying: "Look how many problems people
post to the thread on
a weekly basis where people lose their data when md rebuilds go bad with
non-shared disks" i begin to worry..

> 
> > So my question remains.. Is md raid1 not suited for this need? would it
> > be safer to run in non-raid1 mode and daily(maybe hourly) rsync
> > everything over to the second disk?
> 
> md is 100% guaranteed perfect or your money back...
> rsync is 100% guaranteed perfect or your money back...
> your backups are 100% guaranteed perfect or your money back...
> your hard drives are 100% guaranteed perfect or your money back...
> your CPU and RAM are 100% guaranteed perfect or your money back...
> your CPU and PSU fans are 100% guaranteed perfect or your money back...
> 
> Clearly if you want to panic over reliability you have lots of choices :)

I do not wish to panic, i merely wished to know if linux MD is believed
to work in most cases, or believed to do all sorts of weird stuff when
resyncing :)

> 
> David
> PS, FWIW md has saved my data* countless times over the past 'n' years in
> exactly the scenario you describe.

It has also been useful to people i know, i just wished to be sure :)
and as Keld Jørn Simonsen and Helge Hafting's comments seems to confirm,
linux md IS nice and stable :)

and as said, what im looking for isnt an in-box backup solution, merely
safety in case one disk burns :)

> 
> *(or more accurately has saved me from having to restore my data)

