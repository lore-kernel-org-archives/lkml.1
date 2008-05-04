Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYEDUAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYEDUAa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 16:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbYEDUAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 16:00:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65378 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbYEDUAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 16:00:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 17/56] microblaze_v2: checksum support
Date: Sun, 4 May 2008 21:59:53 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu> <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
In-Reply-To: <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805042159.55077.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19cUCwLLB8Ht6vEPVXolZf9TStZ4RBuL0aQ9RA
 RN63Hhh1auXiZTyVuJ7cjJe1SYSpbeLBFf5tdKRSwZHizhQRXV
 6/R2reIGCxe6OAC1s4QYw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008, monstr@seznam.cz wrote:
> + *
> + * INET                An implementation of the TCP/IP protocol suite for the LINUX
> + *             operating system.  INET is implemented using the  BSD Socket
> + *             interface as the means of communication with the user level.
> + *
> + *             IP/TCP/UDP checksumming routines
> + *
> + * Authors:    Jorge Cwik, <jorge@laser.satlink.net>
> + *             Arnt Gulbrandsen, <agulbra@nvg.unit.no>
> + *             Tom May, <ftom@netcom.com>
> + *             Andreas Schwab, <schwab@issan.informatik.uni-dortmund.de>
> + *             Lots of code moved from tcp.c and ip.c; see those files
> + *             for more names.

This is a pretty generic implementation, and you copied it from another
architecture. How about moving it from arch/microblaze/lib/ to lib/?
I'd suggest building it conditionally under CONFIG_GENERIC_CSUM,
which you def_bool in your architecture Kconfig.

	Arnd <><
