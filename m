Return-Path: <linux-kernel-owner+w=401wt.eu-S1761361AbZENIpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761361AbZENIpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 04:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbZENIpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 04:45:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63199 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZENIpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 04:45:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 0/14] score - New architecure port to SunplusCT S+CORE
Date: Thu, 14 May 2009 10:44:55 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, Kyle McMartin <kyle@mcmartin.ca>
References: <OFC83335DE.A18F9B53-ON48257592.00273C99-48257592.002856A8@sunplusct.com>
In-Reply-To: <OFC83335DE.A18F9B53-ON48257592.00273C99-48257592.002856A8@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905141044.56426.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/hRu/0gOsV8ZkIK+039idrYOKQLworW8cfPLs
 HYQZsgFY/KpLOQ2U/bkNhFrtTbGOUJb02oBahtXFCXA9vCVis6
 35SrVZvjr1yRCm1sgH04Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liquin,

Have you had a chance to look at the asm-generic header files I posted
a few times?

I think it would be ideal if you can change your code to use the
asm-generic version whereever possible, by replacing your files
with something like

arch/score/include/asm/foo.h:
#include <asm-generic/foo.h>

In particular, all of the exported header files that get included
in user space should use only the asm-generic version, with the
exception of byteorder.h, elf.h and ptrace.h, which are by definition
architecture specific.

Please tell me if you find problems in the generic header files during
the conversion.

	Arnd <><
