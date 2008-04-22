Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYDVNQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYDVNQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYDVNPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:15:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49726 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381AbYDVNPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:15:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Will Newton" <will.newton@gmail.com>
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
Date: Tue, 22 Apr 2008 15:15:26 +0200
User-Agent: KMail/1.9.9
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, monstr@seznam.cz, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com>
In-Reply-To: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804221515.28075.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18z/Gyi7qzTAHF41shpe5l/c+/pijN2c4CF1RO
 2UYK47v8OJfVEM7ii/Ft0tzbaf27NB8pdSiuODAN1vWr4a5C1j
 RWsN2vnsasKKgemN6DJRg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2008, Will Newton wrote:
> This patch introduces a __ARCH_WANT_SYS_SYSFS #define for
> architectures that support the sysfs(2) system call. At the moment
> that's everybody but blackfin, but future architectures may want to
> save the (admittedly small) code size that it adds to the kernel as
> well.

Yes, good thing to have. Since we'll be getting a new architecture
(microblaze) soon, I think we should extend this mechanism (even though
it's ugly) to all syscalls that we don't want to have in new architectures
and make sure that microblaze doesn't have to set any of them.

	Arnd <><
