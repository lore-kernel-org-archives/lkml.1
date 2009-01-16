Return-Path: <linux-kernel-owner+w=401wt.eu-S934770AbZAPR0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934770AbZAPR0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 12:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbZAPRZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 12:25:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49389 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574AbZAPRZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 12:25:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: dedekind@infradead.org
Subject: Re: [PATCH] UBI: add ioctl compatibility
Date: Fri, 16 Jan 2009 18:25:37 +0100
User-Agent: KMail/1.9.9
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1232036381.25068.10.camel@localhost.localdomain> <200901161324.35271.arnd@arndb.de> <1232116447.25068.27.camel@localhost.localdomain>
In-Reply-To: <1232116447.25068.27.camel@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901161825.38029.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+kPfeyo8j2mnviVj/ZXogOhCBDd28RpkOCWfN
 g2ApI/usA6M8CVdTM2fh/9DUAMZBPw7wiyEEWtkDz2+FXXOCoB
 dupd3nTq9owLKCRCCThXA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Subject: [PATCH] UBI: add ioctl compatibility
> 
> UBI ioctl's do not work when running 64-bit kernel and 32-bit
> user-land. Fix this by adding the compat_ioctl method.
> 
> Also, UBI serializes all ioctls, so more than one ioctl at a time
> is not a problem. Amd UBI does not seem to depend on anything else,
> so use unlocked_ioctl instead of ioctl (no BKL needed).
> 
> Reported-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Looks good now, thanks!

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
