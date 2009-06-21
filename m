Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbZFUUWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbZFUUWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 16:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbZFUUW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 16:22:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:51774 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbZFUUW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 16:22:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marco <marco.stornelli@gmail.com>
Subject: Re: [PATCH 06/14] Pramfs: Include files
Date: Sun, 21 Jun 2009 22:22:24 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <4A33A7EC.6070008@gmail.com> <200906140059.57362.arnd@arndb.de> <4A3E68CD.6080803@gmail.com>
In-Reply-To: <4A3E68CD.6080803@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906212222.25434.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19VzaRDtKWmXWDu7WCKfODWOU+iTqkh67HzLrv
 065unIA0sQ+IViYfuhzbZPza6BKBpgUf26PK3Hr6SJMNEtRXZ3
 didwlfj4S2sRnSPHg8Uwg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 June 2009, Marco wrote:
> I was thinking about your comment and I think I'll use __kernel_off_t
> for the exported headers. I know that it will differ between 32 and 64
> bit architectures, but for this kind of fs there isn't any compatibility
> problem at layout level. You cannot remove a chip of RAM from a board
> 32bit little endian and attach it to a board with a cpu 64bit big
> endian, the memory isn't a disk. Indeed, I see that tmpfs uses simply
> "unsigned long" in the exported header file without any problems to
> little or big endian.

It's still a problem. You might be creating a file system image
for an embedded board with a different endianess. Or even on the
same machine, you could be looking at the file system contents
with a 32 bit process running on a 64 bit kernel.

	Arnd <><
