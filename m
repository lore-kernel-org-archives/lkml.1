Return-Path: <linux-kernel-owner+w=401wt.eu-S1764279AbZDAR4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764279AbZDAR4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756762AbZDAR4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:56:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49182 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbZDAR4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:56:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
Subject: Re: [RFC] asm-generic/{unistd,types,posix_types}.h for new arch
Date: Wed, 1 Apr 2009 19:55:52 +0200
User-Agent: KMail/1.9.9
Cc: michal.simek@petalogix.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
       Chen Liqin <liqin.chen@sunplusct.com>
References: <49D071A8.4010703@petalogix.com> <200903301717.57184.arnd@arndb.de> <200904011611.53355.arnd@arndb.de>
In-Reply-To: <200904011611.53355.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904011955.53235.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19bq8wUhJUby1/ki7IEm5tiwm2XvT7jtUHOEvk
 I4M5UpWAg5CB1gAkrBcv0nhVKd/46gAtjmLq53QyUJ60usXOqa
 45jaJKmvuVpVoRYyGCTjw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 April 2009, Arnd Bergmann wrote:
> +/* fs/readdir.c */
> +#define __NR3264_getdents __LINE__
> +__SC_3264(__NR3264_getdents, sys_getdents64, sys_getdents)

Just noticed myself that getdents64 changed more than just off_t
(namely the file type) and should be used even on 64-bit platforms,
so I'm putting sys_getdents into my deprecated list now.

	Arnd <><
