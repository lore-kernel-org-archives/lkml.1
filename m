Return-Path: <linux-kernel-owner+w=401wt.eu-S1760960AbZE2O5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbZE2O5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 10:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758309AbZE2O5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 10:57:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61376 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbZE2O5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 10:57:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] mtd: Delete final remnants of MTD ioctls from fs/compat_ioctl.c
Date: Fri, 29 May 2009 15:56:11 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: Kevin Cernekee <kpc.mtd@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
References: <1243607412.19886.169.camel@macbook.infradead.org>
In-Reply-To: <1243607412.19886.169.camel@macbook.infradead.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200905291556.13482.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19FfypkI6fivqBxc2gNw+HPmEu+I6i5TODgAuY
 SBaAuZSvQoLpuvICYx/aLOk7iy3MuR3d3I1SgvD1YyJkfwdNx+
 2UFHFeBBbEGf5vx05BU+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 May 2009, David Woodhouse wrote:
> Er, that doesn't move stuff into mtdchar.c. It just deletes it...

The changeset comment could be a little more verbose, but it looks
correct to me. The key is calling mtd_ioctl() in the 'default:'
case of mtd_compat_ioctl(), which just treats all unhandled
ioctl numbers as compatible.

	Arnd <><
