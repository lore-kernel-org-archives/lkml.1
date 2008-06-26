Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbYFZPSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbYFZPSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYFZPSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:18:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:59917 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYFZPSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:18:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 33/60] microblaze_v4: includes SHM*, msgbuf
Date: Thu, 26 Jun 2008 17:18:17 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <1214483429-32360-33-git-send-email-monstr@seznam.cz> <1214483429-32360-34-git-send-email-monstr@seznam.cz>
In-Reply-To: <1214483429-32360-34-git-send-email-monstr@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806261718.18006.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19wRRCH9eS94/OWmTwrzWBIPc+BmO0AVjUONjy
 nQqhP2eTiyakjizP9KeqJDZBnUzT8LzHtLyAjhC7WwgP5N71X/
 x7ZBoAX8UfT3wKDO8V/2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, monstr@seznam.cz wrote:
>  include/asm-microblaze/msgbuf.h   |   39 ++++++++++++++++++++++++++++
>  include/asm-microblaze/shmbuf.h   |   50 +++++++++++++++++++++++++++++++++++++
>  include/asm-microblaze/shmparam.h |   14 ++++++++++
>  3 files changed, 103 insertions(+), 0 deletions(-)
>  create mode 100644 include/asm-microblaze/msgbuf.h
>  create mode 100644 include/asm-microblaze/shmbuf.h
>  create mode 100644 include/asm-microblaze/shmparam.h
> 

These files are ok, but IMHO they should be in asm-generic, since there
are already many identical copies.

While the implementation of these three, as well as ipcbuf.h and sembuf.h
could be better optimized for endianess and word size differences, I have
come to the conclusion that there is no point for them to really be
different, and uClibc expects this exact layout by default anyway.

	Arnd <><
