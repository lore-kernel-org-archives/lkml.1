Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbZFVSdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbZFVSdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbZFVSdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:33:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:58667 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbZFVSdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:33:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marco <marco.stornelli@gmail.com>
Subject: Re: [PATCH 06/14] Pramfs: Include files
Date: Mon, 22 Jun 2009 20:33:20 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <4A33A7EC.6070008@gmail.com> <200906221317.04166.arnd@arndb.de> <4A3FC7F1.5050108@gmail.com>
In-Reply-To: <4A3FC7F1.5050108@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906222033.20883.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/k7dNG2Z8oTn7WUAu1A0c8FfVkLChtBiTL0oR
 peP+b8fGGRUZG7XAQL+Ky4m/oM6R0Nc4vo1lc6fciIOgjfjiAZ
 8M/+NxgU1JZWWfxBjtPwLIoAsy7QPbA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, Marco wrote:
> 
> Sorry, I meant it's not currently possible. At the moment the only way
> to use it as rootfs it's to copy all the data in an already mounted
> (empty) ram partition and reboot. However it's not my first item on my
> todo list because I think that it's possible to use it as rootfs but it
> isn't the standard use for this fs.

Well, it doesn't have to work right away. What I'm asking to
define the data structures in a way that keeps the layout stable
across kernel updates. Since a future version of the file system
might support cross-endian image creation, it would be good to
define the data structures in a fixed endian mode already, so
you don't have to change it in the future.

	Arnd <><
