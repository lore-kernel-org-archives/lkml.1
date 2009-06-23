Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbZFWV4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbZFWV4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZFWVz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:55:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55364 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbZFWVz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:55:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 06/14] Pramfs: Include files
Date: Tue, 23 Jun 2009 23:55:32 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: =?utf-8?q?J=C3=B6rn_Engel?= <joern@lazybastard.org>,
       Marco <marco.stornelli@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Tim Bird <tim.bird@am.sony.com>, Chris Simmonds <chris@2net.co.uk>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <4A33A7EC.6070008@gmail.com> <20090623192648.GB23119@logfs.org> <1245791743.25547.3517.camel@macbook.infradead.org>
In-Reply-To: <1245791743.25547.3517.camel@macbook.infradead.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906232355.34134.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX189cfSYKGgxCW6zV3L0qxYVYnoYkzbNhGwIDOf
 fAu0kmENo/R/sHwBVcPhQu/Uhz6fbyG9iYI/qdqR3ZL+Ebgcdz
 O08tSm0XN37C1FLsu2Alg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, David Woodhouse wrote:
> And dd on /dev/mem would work, surely?

Actually, reading from /dev/mem is only valid on real RAM. If the nvram
is part of an IO memory mapping, you have to do mmap()+memcpy() rather
than read(). So dd won't do it, but it's still easy to read from user
space.

> I'd definitely recommend making it fixed-endian. Not doing so for JFFS2
> was a mistake I frequently regretted.

Right.

	Arnd <><
