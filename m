Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbYEDV6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbYEDV6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 17:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYEDV6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 17:58:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:51098 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbYEDV6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 17:58:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 38/56] microblaze_v2: atomic.h bitops.h byteorder.h
Date: Sun, 4 May 2008 23:58:13 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <4e20213f5f296268a24955df8c951f7fba279816.1209897266.git.monstr@monstr.eu> <49eccf3408b90a5ebb42635493bbeef3b584acb9.1209897266.git.monstr@monstr.eu>
In-Reply-To: <49eccf3408b90a5ebb42635493bbeef3b584acb9.1209897266.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805042358.15131.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ZddOICHZNrxGSegCw5mVWwptXjNyPa6f9vq7
 STHJQZdoXkuNNoSzaTOuFiwe8SPr2jGuoyBO8H7x90+ydQKcgi
 KfYASCrtAJYhPUAi5UiHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008, monstr@seznam.cz wrote:
>  include/asm-microblaze/atomic.h    |  108 ++++++++++++++++++++++++++++++++++++

It would be cool if you could introduce this file as 
asm-generic/atomic-irqdisable.h or similar (can someone please
think of a better name?).

It looks like it could be shared with blackfin, h8300, m32r, m68k,
mn10300 and v850. Not important though, as this is not part of the
ABI.

	Arnd <><
