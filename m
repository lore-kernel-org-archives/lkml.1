Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbXIFWQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbXIFWQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 18:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbXIFWQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 18:16:51 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:56638 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755313AbXIFWQu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 18:16:50 -0400
From: Daniel Exner <dex@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: Kernel Panic on 2.6.23-rc5
Date: Fri, 7 Sep 2007 00:14:08 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200709062044.54626.dex@dragonslave.de> <6bffcb0e0709061206n4146da2anf11f15218e8e0091@mail.gmail.com>
In-Reply-To: <6bffcb0e0709061206n4146da2anf11f15218e8e0091@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709070014.08735.dex@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;dex@dragonslave.de;1189117010;8b1d21e5;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

06 September 2007 Michal Piotrowski wrote:
[..]
> > CPU 0: Machine Check Exception: 0000000000000004
> > Bank 4: b200000000070f0f
> > Kernel panic - not syncing: CPU context corrupt
>
> It is a hardware problem.
>
> You may want to use mcelog ftp://ftp.x86-64.org/pub/linux/tools/mcelog/
Tried this on grml64 (cause I'm normaly on x86)
Results:

--
WARNING: with --dmi mcelog --ascii must run on the same machine with the
     same BIOS/memory configuration as where the machine check occurred.
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 0 data cache STATUS 0 MCGSTATUS 4
Bank 4: b200000000070f0f
Kernel panic - not syncing: CPU context corrupt
---

This really doesnt say me anything the above didn't.
Next thing I tried was:

parsemce-e 0 -b 4 -s b200000000070f0f -a 0
Output:
Status: (0) Restart IP invalid.
parsebank(4): b200000000070f0f @ 0
        External tag parity error
        CPU state corrupt. Restart not possible
        Error enabled in control register
        Error not corrected.
        Bus and interconnect error
        Participation: Generic
        Timeout:
        Request: Generic error
        Transaction type : Invalid
        Memory/IO : Other


Wich doesnt tell me anything either :(

Google suggest anything from broken CPU(bad), broken RAM(even more bad) to 
broken mainboard(Ouch..)

I'm going to let memtest run overnight. This is the easiest test I guess :)
-- 
Greetings
Daniel Exner
-- 
Mit freundlichen Grüßen
Daniel Exner
