Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbYFZRrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbYFZRrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYFZRrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:47:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61953 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYFZRrm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:47:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 52/60] microblaze_v4: fcntl.h sockios.h ucontext.h
Date: Thu, 26 Jun 2008 18:46:12 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <1214483429-32360-53-git-send-email-monstr@seznam.cz> <200806261743.10441.arnd@arndb.de>
In-Reply-To: <200806261743.10441.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806261846.13599.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/IEGEhOG3o9MV9iE8eqa82eoVeJLpdZp4sTWz
 ampNsJZBBr2+/FKduvEHm2VzpgisXpnINrBkmPPDcf57j//bwU
 C2DLUOFq6Unu1R6C0hU+g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, Arnd Bergmann wrote:
> On Thursday 26 June 2008, monstr@seznam.cz wrote:
> >  include/asm-generic/sockios.h     |   23 +++++++++++++++++++++++
> >  include/asm-generic/ucontext.h    |   24 ++++++++++++++++++++++++
> >  include/asm-microblaze/fcntl.h    |    1 +
> >  include/asm-microblaze/sockios.h  |   23 +++++++++++++++++++++++
> >  include/asm-microblaze/ucontext.h |    1 +
> 
> Also, the sockios file here looks like it should be in asm-generic.

I just realized that you are adding the same sockios file to both
asm-generic and asm-microblaze, so I guess that is just an oversight
and you meant the microblaze file to be just a redirection.

Note that when you add an asm-generic header file that contains
a user interface, you need to add it to asm-generic/Kbuild as well
in order to get it installed correctly with make headers_install.

Running make headers_check should tell you about this problem if
it exists in other places.

	Arnd <><
