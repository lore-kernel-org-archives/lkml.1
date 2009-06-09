Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbZFIRUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbZFIRUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbZFIRUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:20:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55009 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZFIRUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:20:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 07/27] score: create head files elf.h emergency-restart.h errno.h
Date: Tue, 9 Jun 2009 19:20:09 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
References: <OF1B185198.8D225D85-ON482575D0.00235FF4-482575D0.0023D06F@sunplusct.com>
In-Reply-To: <OF1B185198.8D225D85-ON482575D0.00235FF4-482575D0.0023D06F@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906091920.09781.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/MY+aW1FveqaQMyWAhU2YKqYrb+qjZ0mCVRHQ
 aMO+YneHn6T4mFuTlxY3C6fhAMEkPusu/SNBaxtgeuvM2E5sP+
 Alr8XacnZyrhCHOZdGFQtunv3raEsC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:
> --- /dev/null
> +++ b/arch/score/include/asm/errno.h
> @@ -0,0 +1,7 @@
> +#ifndef _ASM_SCORE_ERRNO_H
> +#define _ASM_SCORE_ERRNO_H
> +
> +#include <asm-generic/errno.h>
> +#define EMAXERRNO 1024
> +
> +#endif /* _ASM_SCORE_ERRNO_H */

EMAXERRNO is mips specific right now. Do you actually need it somewhere?

	Arnd <><
