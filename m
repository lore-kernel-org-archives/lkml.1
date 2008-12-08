Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbYLHUbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbYLHUbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 15:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYLHUa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 15:30:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55018 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYLHUa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 15:30:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Artem Bityutskiy <dedekind@yandex.ru>
Subject: Re: UBI/DVB ioctl conflict?
Date: Mon, 8 Dec 2008 21:30:13 +0100
User-Agent: KMail/1.9.9
Cc: dedekind@infradead.org, Laurent Pinchart <laurentp@cse-semaphore.com>,
       linux-mtd@lists.infradead.org, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       v4l-dvb-maintainer@linuxtv.org, LKML <linux-kernel@vger.kernel.org>
References: <20081207095811.13b51cca@zod.rchland.ibm.com> <200812081650.54346.arnd@arndb.de> <493D4C63.5040502@yandex.ru>
In-Reply-To: <493D4C63.5040502@yandex.ru>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812082130.14420.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19i5RJ5qlCqD6w5Cr9hM3Y8xk3qk3BbMgtJS/t
 9METkNov+9YJ+/VYu+6XuAVB/TI+Iv3I6nKUbX1FJTlw4KHbq7
 s5yuOwkH1AIXR++MPbWlg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2008, Artem Bityutskiy wrote:
> Arnd Bergmann wrote:
> > We try hard (but sometimes fail) to keep every ioctl number unique.
> > The reason for this is that the device drivers are not the only
> > pieces of code that look at them. Specifically, three other things
> > frequently cause problems here:
> 
> Thanks for the reply. Do you know the status of the
> Documentation/ioctl/ioctl-number.txt file - it does not seem to be up-to-date.
> Should I document add UBI ioctls there?

Yes, please. The best we can do is if everyone documents his own stuff.

	Arnd <><
