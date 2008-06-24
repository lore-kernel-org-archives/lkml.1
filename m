Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbYFXHhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbYFXHhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 03:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYFXHhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 03:37:04 -0400
Received: from mail.mba-software.de ([62.75.137.201]:46162 "EHLO
	mail.mba-software.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbYFXHhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 03:37:03 -0400
X-Greylist: delayed 3709 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jun 2008 03:37:03 EDT
Message-ID: <4860959E.6020207@mba-software.de>
Date: Tue, 24 Jun 2008 08:35:10 +0200
From: =?ISO-8859-15?Q?Marian_Aldenh=F6vel?= 
	<marian.aldenhoevel@mba-software.de>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Building a kernel for SiS55-based system.
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to build a linux kernel for a small form-factor PC. I have so
far failed to create a working kernel.

Output of /cat/proc/cpuinfo as given by the hardware vendor:

  > processor       : 0
  > vendor_id       : SiS SiS SiS
  > cpu family      : 5
  > model           : 0
  > model name      : ff/00
  > stepping        : 5
  > cpu MHz         : 200.008
  > fdiv_bug        : no
  > hlt_bug         : no
  > f00f_bug        : no
  > coma_bug        : no
  > fpu             : yes
  > fpu_exception   : yes
  > cpuid level     : 1
  > wp              : yes
  > flags           : fpu tsc cx8 mmx
  > bogomips        : 398.95

I gather that is a SiS 55x System-on-a-chip.

I am using T2[1] as build-system. It (currently) tries to build the kernel
from 2.6.25.7 sources. When booting the kernel it built the system stops
after:

   Decompressing Linux... done.
   Booting the kernel.

At the bottom of the screen it says:

   BUG: Int6: CR2 00000000

And nothing else.

My kernel-configfile can be downloaded from [2]

I am confident that the build-system in itself is sound. I can boot the
system it created on a variety of different systems including QEmu, but
not on the target with the CPU given above. But I have very very little
experience in building system like this from scratch.

I am quite new at this sort of thing, so please be gentle if I forgot the
most vital part of information required to help me. I will gladly provide
anything asked for.

If someone is really extremely keen on helping I can also send out one
of the machines I am trying to get this up and running on and a copy of
the development host-VM I am using.

Ciao, MM

[1] http://www.t2-project.org
[2] http://www.marian-aldenhoevel.de/tmp/kconfig_2.6.25.7-dist
-- 
Marian Aldenhövel, Rosenhain 23, 53123 Bonn
http://www.marian-aldenhoevel.de
"I ran some quick calculations on it. He's about 80% on the right
  track.  That leaves him only 20% dead when he crashes." Bob C


