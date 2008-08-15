Return-Path: <linux-kernel-owner+w=401wt.eu-S1759789AbYHOPfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789AbYHOPfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbYHOPet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:34:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56474 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbYHOPes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:34:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC: 2.6 patch] s390: use kernel/uid.c
Date: Fri, 15 Aug 2008 17:34:43 +0200
User-Agent: KMail/1.9.9
Cc: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080810204031.GC8399@cs181140183.pp.htv.fi>
In-Reply-To: <20080810204031.GC8399@cs181140183.pp.htv.fi>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808151734.43710.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/LVPJCq0pxe5zF/NszyBCcpndF6EZeO8N50wU
 NuRnDvv7w7bTeh2JSzJ1reuPyszmtQiyeTlBaxo92J4t0Ev+D+
 0G2qXO3T0xkAmK4K5Th2Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 August 2008, Adrian Bunk wrote:
> Unless I missed a twist the only reason for s390 to not use the code in 
> kernel/uid.c was that it copied the code from sparc64 (that is now 
> being changed in a similar way by David).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 

I tried doing this before but couldn't figure out an easy way,
but the circumstances may have changed by now.

Back then, the basic problem was that CONFIG_UID16 had side-effects
that break the 64-bit versions of some syscalls. I don't see that
being the case any more, but from what I can tell, you still need
to add definitions for __kernel_old_uid_t etc on s390x.

If that does the trick, great work!

	Arnd <><
