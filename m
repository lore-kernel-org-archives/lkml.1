Return-Path: <linux-kernel-owner+w=401wt.eu-S1761570AbXLUM4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570AbXLUM4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbXLUM4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:56:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55195 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbXLUM4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:56:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH -mm 05/43] compat_binfmt_elf
Date: Fri, 21 Dec 2007 13:55:04 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20071220115200.C767E26F98A@magilla.localdomain> <20071220115447.4F8E326F98A@magilla.localdomain>
In-Reply-To: <20071220115447.4F8E326F98A@magilla.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712211355.05173.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+cMwPCkNTjoLCuwnXocncXUosEHwM3xFHs1Zh
 SdtHbOuxvNRShvkCHMT/373c4Sb2pFE8nsoLuuVAHlX7S+wphi
 SoBMTrrykBvPdCXmNVEhw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2007, Roland McGrath wrote:
> This adds fs/compat_binfmt_elf.c, a wrapper around fs/binfmt_elf.c for
> 32-bit ELF support on 64-bit kernels.  It can replace all the hand-rolled
> versions of this that each 32/64 arch has, which are all about the same.

Great stuff! I've attempted to do this a few times over the past years,
but could never get my head around it. One more bit of broken compat
code gone from the architectures!

	Arnd <><
