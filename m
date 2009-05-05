Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbZEELjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbZEELjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 07:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZEELjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 07:39:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:50258 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbZEELjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 07:39:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: compat ioctl32 for /dev/snapshot?
Date: Tue, 5 May 2009 13:38:45 +0200
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, Michael Tokarev <mjt@tls.msk.ru>,
       "Linux-kernel" <linux-kernel@vger.kernel.org>
References: <49FEB572.4010909@msgid.tls.msk.ru> <20090504111243.GH23223@one.firstfloor.org> <200905042355.47109.rjw@sisk.pl>
In-Reply-To: <200905042355.47109.rjw@sisk.pl>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905051338.46436.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+XXu0xB3nPcETN/yifrrEfks8v1vzA8PkAJr0
 onpqJ6HXigrWLxidj4izXQjxa0t5mhFrZ3Om35E3RDVE9w2o/J
 2iCrZ+ss2x4mK6nkbPymg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 May 2009, Rafael J. Wysocki wrote:
> In fact I don't think the 32-bit user space will work with 64-bit kernels as is
> in this particular case, because of the different pointer size.
> 
> Having a quick look at the code (I don't remember the details right now)
> I think most probably it could be modified to handle this case too, but I'm not
> really sure.

I don't see anything in the snapshot code that passes pointers to the
kernel, so why should the pointer size matter?

	Arnd <><
