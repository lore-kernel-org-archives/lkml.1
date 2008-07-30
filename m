Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbYG3HHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbYG3HHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757564AbYG3HHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:07:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60495 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538AbYG3HH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:07:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Ungerer <gerg@snapgear.com>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Date: Wed, 30 Jul 2008 09:07:24 +0200
User-Agent: KMail/1.9.9
Cc: Sam Ravnborg <sam@ravnborg.org>, linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20080728200500.GA14284@uranus.ravnborg.org> <48900EE4.8030606@snapgear.com>
In-Reply-To: <48900EE4.8030606@snapgear.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807300907.25186.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19AVT9f2G1IPMjq9oTKSRFzC1ZAElowXlOntuO
 7h8n1K7gAbvndzUMnWfKgktAJ2d+zlUmmJG1S9mM1EDufnuzEw
 w2n7KEeiVmSFWAwaVo07Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008, Greg Ungerer wrote:
> I just tried moving the include/asm-m68knommu directory
> to arch/m68knommu/include/asm and it all worked fine.
> Clean compile first go :-)  Nice.  (As noted
> asm-offsets.h was still generated in incldue/asm-m68knommu
> afterwards though).

I think the more interesting aspect in m68knommu is what happens
when asm-m68k gets moved. Does that work as well?

I think the best way to deal with it is to remove all files
that just include an asm-m68k file with the same name, and
add -Iarch/m68k/include to your CFLAGS. Not sure about 'make
headers_install', if there is an easy way to install the
files from each of the two directories correctly.

	Arnd <><
