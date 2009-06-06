Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbZFFNqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbZFFNqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 09:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZFFNqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 09:46:37 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:35357 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbZFFNqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 09:46:36 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: e_powersaver / underclocking (was Re: Linux 2.6.30-rc8 [also: VIA Support])
Date: Sat, 6 Jun 2009 08:46:34 -0500
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906060717.46964.lkml@morethan.org> <20090606132847.GB14088@prithivi.gnumonks.org>
In-Reply-To: <20090606132847.GB14088@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906060846.36303.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat June 6 2009, Harald Welte wrote:
> On Sat, Jun 06, 2009 at 07:17:44AM -0500, Michael S. Zick wrote:
> 
> > I can respond to that point now; VIA Tech has answered some of my questions -
> > 
> > The mainstream kernel, e_powersaver, is *under-clocking* my machine -
> > 
> > The cpuid instruction provides the minimum and maximum GSF values 
> > (Guaranteed Stable Frequency) for that processor mask run -
> > Passing that on as the lower and upper limits to e_powersaver should
> > stop that problem.  Will be testing this RSN.
> 
> It's really surprising to me that none of this seems to be handled correct so
> far, I'll talk to Centaur and try to find out how we could have ended up in
> this situation.
>

Ah, but we are talking here of the *second* NetBook ever produced.
If one is to believe the dmidecode output - it is using the VIA demo board
BIOS. 

I bet the demo board BIOS is intended to demo the features of the product -
not the correctness or completeness of the ACPI support.  ;)

If I where shipping demo boards - they would be demonstrating **my** product's
features.  Maybe I am just projecting what I would do. 


> My assumption is that e_powersavre is no longer supposd to do any of those
> low-level bits - rather the ACPI code is expected to get it right, hiding the
> details from the OS.  But in this case, there needs to be some run-time detection
> whether the ACPI cpufreq should be used, or e_powersaver.  And I don't see any
> of that right now.
> 

I can keep my eyes open for a way to do that -
First, I want to get the machine running **with-in** the specs it can provide.
The one I have is running at 2/3rds of the reported *minimum* clockspeed.
I must have gotten a high quality "mask/process run" for it to be running at all.

> Also note that now with OLPC XO1.5 going for the C7-M (on a VX855 chipset,
> though), many of those issues should soon receive much more attention -
> especially on the power management front.  And as you know, they don't use any
> legacy BIOS...
> 

I'll keep my eyes open on that subject also when looking at the e_powersaver code -
The OLPC project will probably be requesting chip runs that **do** run at
the minimums the design is capable of and it will **have to** be stable for OLPC.

Mike
> Regards,


