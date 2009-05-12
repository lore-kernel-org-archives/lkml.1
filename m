Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbZELLq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbZELLq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbZELLqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:46:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:63966 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbZELLqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:46:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 11/12] microblaze: dont include asm/mmu.h in hw_exception_handler
Date: Tue, 12 May 2009 13:46:43 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
References: <20090511232019.927138561@arndb.de> <200905121313.35501.arnd@arndb.de> <4A095C6B.9030303@monstr.eu>
In-Reply-To: <4A095C6B.9030303@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905121346.43859.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Ssmmarc96nUR8GpBA1vMk3sGnIy9+VcfEsvF
 BKUk+r5tYNNYoDiyxCuo7kHlZI9W/qjbD7uwfElzos6QbXRqB1
 3oN0xVwR0cvjGgI3lm0Qg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 May 2009, Michal Simek wrote:
> I have no problem to remove mmu.h from it but I have to move that one TLB macro to
> different sensible include file. It is related with mmu that's why I think someone in past
> add it to this file. The main point is which file. Any tip?

Since the hardware shares a number of properties with ppc440, I guess you
are right that it makes sense to keep the kernel implementation similar to
arch/powerpc/include/asm/mmu-44x.h. Please keep it the way you have it
now, I'll just add #ifndef __ASSEMBLY__ to the asm-generic file.

	Arnd <><
