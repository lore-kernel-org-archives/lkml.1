Return-Path: <linux-kernel-owner+w=401wt.eu-S1762186AbZAPMYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762186AbZAPMYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbZAPMYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:24:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55731 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbZAPMYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:24:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: dedekind@infradead.org
Subject: Re: [PATCH] UBI: add ioctl compatibility
Date: Fri, 16 Jan 2009 13:24:34 +0100
User-Agent: KMail/1.9.9
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1232036381.25068.10.camel@localhost.localdomain> <200901151734.23870.arnd@arndb.de> <1232104138.25068.22.camel@localhost.localdomain>
In-Reply-To: <1232104138.25068.22.camel@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901161324.35271.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/2shzqaQtQvB1hJDXPH9Qtl80Qy0ZNCGyLpie
 E6k9yiFSDIeimGJvnYeVEaeWN0AoDA9zkgAjGSX5LA5fuw89jx
 zMzl1xcjHZxmztI6zhBow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009, Artem Bityutskiy wrote:
> Thank you Arnd. Here is the corrected patch. Tested on x68_64 + 32-bit
> UBI tools.
> 

Looks better now, but the compat_ versions are still missing the
compat_ptr() conversions. Those only make a difference on s390,
so you wouldn't see the problem on x86_64.

	Arnd <><
