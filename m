Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbYDQNjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbYDQNjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 09:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYDQNjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 09:39:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:52108 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYDQNjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 09:39:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Lutomirski <luto@myrealbox.com>
Subject: Re: Smartmedia/xd card support - request for comments
Date: Thu, 17 Apr 2008 15:36:47 +0200
User-Agent: KMail/1.9.9
Cc: Alex Dubov <oakad@yahoo.com>, Ben Dooks <ben@fluff.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?q?J=F6rn_Engel?= <joern@logfs.org>
References: <20080417090137.GB16284@fluff.org.uk> <257448.48285.qm@web36701.mail.mud.yahoo.com> <48074C35.2020707@myrealbox.com>
In-Reply-To: <48074C35.2020707@myrealbox.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804171536.47999.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18NMFf5NvTKdCcEkLUbSk7P+4hmQCX+YvWuHzR
 /DSpE0rK1nIuW4shH9JoTKl0pwOdXPAZ/9Nm7qWXzDBqevI/A5
 8173vs8bT5OpY7b6CeIKQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2008, Andy Lutomirski wrote:
> > 
> > They have nothing to do with JFFS or UBI (it's an interchange format).
> > They require FTL.
> 
> Or does using them according to the interchange spec require FTL?
> 
> (That is, it would be really cool to finally have a supported MTD device 
> that doesn't need to be soldered on to the motherboard, so I could plug 
> the thing in and run UBIFS / JFFS2 / whatever.  I wouldn't be able to 
> use it for a camera, then, but it would be great for little machines 
> that don't need full hard drives, or for developing MTD filesystems on 
> readily-available hardware.)

There is one MTD driver for Smartmedia/xD in the kernel, see
drivers/mtd/nand/alauda.c. It is derived from the USB mass storage
driver drivers/usb/storage/alauda.c, which contains another copy of
the SM FTL.

	Arnd <><
