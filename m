Return-Path: <linux-kernel-owner+w=401wt.eu-S933623AbYETTG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623AbYETTG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933477AbYETTGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:06:36 -0400
Received: from mail.lang.hm ([64.81.33.126]:35994 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932779AbYETTGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:06:34 -0400
Date: Tue, 20 May 2008 12:12:58 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Harald Dunkel <harald.dunkel@t-online.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
In-Reply-To: <48331FFF.5070300@t-online.de>
Message-ID: <alpine.DEB.1.10.0805201211390.4804@asgard.lang.hm>
References: <4829326A.6060808@t-online.de> <19f34abd0805122347x4d9c5d03m16679d724189790e@mail.gmail.com> <4829D345.7020909@t-online.de> <19f34abd0805140034j75d97ecbw5a03c200645768cb@mail.gmail.com> <482B1BD2.8040400@t-online.de>
 <19f34abd0805141017g26c13e96t2e7edc23bec263d0@mail.gmail.com> <20080514183558.40178fe5@core> <48306DCA.9070108@t-online.de> <20080518185104.0a539f25@core> <48331FFF.5070300@t-online.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Harald Dunkel wrote:

> Alan Cox wrote:
>>> This GDB was configured as "x86_64-linux-gnu"...
>>> Attaching to program: /var/tmp/coreutils-6.10/coreutils-6.10/src/stty, 
>>> process 26465
>>> /tmp/buildd/gdb-6.8/gdb/linux-nat.c:988: internal-error: linux_nat_attach: 
>>> Assertion `pid == GET_PID (inferior_ptid) && WIFSTOPPED (status) && 
>>> WSTOPSIG (status) == SIGSTOP' failed.
>>> A problem internal to GDB has been detected,
>> 
>> So your gdb is broken, your stty is doign stuff nobody else seems to be
>> seeing ? My first thought is to suspect the distro/source as I've still
>> had no other equivalent reports and given the gdb spew.
>> 
>
> I doubt that Debian is to blame here. I get the same with native
> gdb-6.8 and native coreutils-6.10:

try killing syslog and then see if you continue to have the problem. It's 
possible that what's happening is syslog is getting stuck and su is 
sitting waiting for syslog to process the log entry.

David Lang
