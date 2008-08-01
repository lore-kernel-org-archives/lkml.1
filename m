Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbYHAHfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbYHAHfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 03:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYHAHf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 03:35:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63130 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbYHAHf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 03:35:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Date: Fri, 1 Aug 2008 09:35:04 +0200
User-Agent: KMail/1.9.9
Cc: Paul Mundt <lethal@linux-sh.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@snapgear.com>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       uClinux list <uclinux-dev@uclinux.org>
References: <200807300907.25186.arnd@arndb.de> <200807312147.25837.arnd@arndb.de> <20080731201352.GB25305@uranus.ravnborg.org>
In-Reply-To: <20080731201352.GB25305@uranus.ravnborg.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808010935.05949.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+pViZ2GxCx2Gxc7u6mQppB7CgIAtT6kPKVFTC
 BkBA2K//6b3ku2Nevkwkzfvyfx8AgSklb2Q4lpBZ6aNQpx1f4N
 WstozlkGx+9TWGG9R/DsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008, Sam Ravnborg wrote:
> > #ifdef __KERNEL__
> > #ifdef CONFIG_MMU
> > #include "${BASE}_mmu.h"
> > #else
> > #include "${BASE}_nommu.h"
> > #endif
> > #else
> > #include "${BASE}_mmu.h"
> > #endif
> > EOF
> > }
> 
> This will leak a CONFIG_ symbol if the header file
> is exported. Can we do it with a gcc defined symbol?
> [See how I did it for sparc for instance]

Is there a compiler defined symbol for this? I thought the tool
chain was identical. Do you think my #ifdef __KERNEL__ does
not do what I wanted it to do? It should make sure that
user space always sees the _mmu variant.

	Arnd <><
