Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbZFDUjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbZFDUjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbZFDUjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:39:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33325 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbZFDUjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:39:36 -0400
Message-ID: <4A283102.9020404@redhat.com>
Date: Thu, 04 Jun 2009 22:39:30 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Harald Welte <HaraldWelte@viatech.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>, "Michael S. Zick" <lkml@morethan.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906040856.10512.lkml@morethan.org> <200906040958.46018.lkml@morethan.org> <alpine.LFD.2.01.0906040817090.4880@localhost.localdomain> <e9e943910906040900j6f334f29l42a9f5a57e9a1c8f@mail.gmail.com> <alpine.LFD.2.01.0906040910280.4880@localhost.localdomain> <20090604170820.GA9823@prithivi.gnumonks.org>
In-Reply-To: <20090604170820.GA9823@prithivi.gnumonks.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Hi,

> I'm more than determined to help resolving those sporadic Linux lock-up
> problems. It feels like there is some problem out there, given the fact that
> there is a number of independent reporters who talk about some kind of hard
> system hang without oops that even prevents the NMI watchdog to kick in.

Data point:  I have trouble with an (oldish) via box too.

processor       : 0
vendor_id       : CentaurHauls
cpu family      : 6
model           : 9
model name      : VIA Nehemiah
stepping        : 3

It has a quite interesting error pattern:  It runs rock solid in summer, 
it has stability issues in winter.  It is located in a server rack in a 
basement, so the weather out there shouldn't make a big difference to 
the machine.  I'm really curious what this might be ...

"stability issues" means it does either lock up or reboot, usually 
without anything on the serial console.  Seems to be more likely under 
load.  The periods of time the machine runs can range from hours to weeks.

cheers,
   Gerd
