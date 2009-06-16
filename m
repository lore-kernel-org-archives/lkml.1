Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZFPONu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZFPONu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZFPONk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:13:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56527 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZFPONj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:13:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: add EMAXERRNO
Date: Tue, 16 Jun 2009 16:13:07 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, torvalds@linux-foundation.org
References: <OFD9F2472F.5C67128A-ON482575D7.000F7E83-482575D7.0011466D@sunplusct.com>
In-Reply-To: <OFD9F2472F.5C67128A-ON482575D7.000F7E83-482575D7.0011466D@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Message-Id: <200906161613.07979.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+ykWugKAfOqPrqCKrRgbfVALfyECJV7XRgwB2
 SNUXPydp2GtJDWo/JoXtQIjCX4v8YWtPzQzrhwkzOZN1hOpbLp
 tEjJZ+JAUvqMd4MVWusIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 June 2009, liqin.chen@sunplusct.com wrote:
> But I think move MAX_ERRNO define from include/linux/err.h to 
> include/asm-generic/errno.h will be more clear. And no harm to
> include/linux/err.h file.

Don't know. I think err.h makes more sense because that is
for kernel-internal users like the much more common IS_ERR(),
while include/asm-generic/errno.h is strictly for kernel/user
interfaces.

	Arnd <><
