Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYECVPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYECVPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYECVOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:14:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:55399 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbYECVOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:14:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ulrich Drepper <drepper@redhat.com>
Subject: Re: microblaze syscall list
Date: Sat, 3 May 2008 23:14:23 +0200
User-Agent: KMail/1.9.9
Cc: John Williams <john.williams@petalogix.com>, monstr@seznam.cz,
       Matthew Wilcox <matthew@wil.cx>, Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <200805031116.50236.arnd@arndb.de> <481C8B48.5020306@redhat.com>
In-Reply-To: <481C8B48.5020306@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805032314.24669.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/jnnfo+4YInEyCXipXMCuHv7Zu7eUGYCfCDdm
 ypfY3TXfmigFQc9WV/9grMl0tTlMet/Fu710ByEF+PwVrGL6KJ
 HPp5lkQZRHtOLMDt2j3rA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 May 2008, Ulrich Drepper wrote:
> Yes, this is how it should be.  It's not done because no architecture
> glibc officially supports arrived after these and similar syscalls
> arrived.  There is no need to implement the not-*at interface, no need
> to implement the creat syscall, etc etc.

Ah, good! So where should the glibc implementation for these calls go?
In the microblaze (and any future architecture) specific source directories,
to be consolidated when you get more of them, or in the common places like
sysdeps/unix/sysv/linux/*.c, with the appropriate #ifndef?

	Arnd <><
