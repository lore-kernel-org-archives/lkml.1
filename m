Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbYEEOET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbYEEOET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbYEEOEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:04:09 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:57184 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752032AbYEEOEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:04:08 -0400
Message-ID: <481F1414.6020203@seznam.cz>
Date: Mon, 05 May 2008 16:05:08 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 17/56] microblaze_v2: checksum support
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu> <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu> <200805042159.55077.arnd@arndb.de>
In-Reply-To: <200805042159.55077.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> + *
>> + * INET                An implementation of the TCP/IP protocol suite for the LINUX
>> + *             operating system.  INET is implemented using the  BSD Socket
>> + *             interface as the means of communication with the user level.
>> + *
>> + *             IP/TCP/UDP checksumming routines
>> + *
>> + * Authors:    Jorge Cwik, <jorge@laser.satlink.net>
>> + *             Arnt Gulbrandsen, <agulbra@nvg.unit.no>
>> + *             Tom May, <ftom@netcom.com>
>> + *             Andreas Schwab, <schwab@issan.informatik.uni-dortmund.de>
>> + *             Lots of code moved from tcp.c and ip.c; see those files
>> + *             for more names.
> 
> This is a pretty generic implementation, and you copied it from another
> architecture. How about moving it from arch/microblaze/lib/ to lib/?
> I'd suggest building it conditionally under CONFIG_GENERIC_CSUM,
> which you def_bool in your architecture Kconfig.
> 
> 	Arnd <><
I move checksum.c to /lib and checksum.h to asm-generic and add to GENERIC_CSUM
to Kconfig

   6 config MICROBLAZE
   7         def_bool y
   8         select HAVE_LMB
   9         select GENERIC_CSUM

M
