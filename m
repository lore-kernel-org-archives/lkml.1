Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbYEEJyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbYEEJyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYEEJyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:54:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54294 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbYEEJye convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:54:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 46/56] microblaze_v2: headers files entry.h current.h mman.h registers.h sembuf.h
Date: Mon, 5 May 2008 11:54:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <8e1d421649250f7a3f638cd552bc46e5f5845890.1209897267.git.monstr@monstr.eu> <5b1319d426b1f55e08402790b4bc16a33ec7c00c.1209897267.git.monstr@monstr.eu>
In-Reply-To: <5b1319d426b1f55e08402790b4bc16a33ec7c00c.1209897267.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805051154.28761.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+PeDV/E7Jvs3xX1NCFw6ois3dIghXgaet9spk
 wYEfmFh4AcISh1t98K4Ts1RQYn4/6OgPo+L+GktuxVBqLCrsqM
 jH1T6M3Q4oaqclsHzfyuw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008, monstr@seznam.cz wrote:
> +#ifndef _ASM_MICROBLAZE_MMAN_H
> +#define _ASM_MICROBLAZE_MMAN_H
> +
> +#include <asm-generic/mman.h>
> +
> +#define MAP_GROWSDOWN  0x0100 /* stack-like segment */
> +#define MAP_DENYWRITE  0x0800 /* ETXTBSY */
> +#define MAP_EXECUTABLE 0x1000 /* mark it as an executable */
> +#define MAP_LOCKED     0x2000 /* pages are locked */
> +#define MAP_NORESERVE  0x4000 /* don't check for reservations */
> +#define MAP_POPULATE   0x8000 /* populate (prefault) pagetables */
> +#define MAP_NONBLOCK   0x10000 /* do not block on IO */
> +
> +#define MCL_CURRENT    1 /* lock all current mappings */
> +#define MCL_FUTURE     2 /* lock all future mappings */
> +
> +#endif /* _ASM_MICROBLAZE_MMAN_H */

I think we should come up with a good way to fold these into the
asm-generic header, as half the architectures use the same values
for them, in addition to what is already shared.

	Arnd <><
