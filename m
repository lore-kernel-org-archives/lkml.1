Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbZEWLWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbZEWLWn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 07:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbZEWLWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 07:22:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64075 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbZEWLWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 07:22:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: "make config" to another architecture doesn't relink include/asm
Date: Sat, 23 May 2009 13:22:15 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, sam@ravnborg.org
References: <alpine.LFD.2.00.0905221219500.13933@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905221219500.13933@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905231322.16154.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+jn5AhLFrNs9r9E22NpnxAq3OQmHhKyhe/md9
 GmIMXAXURx91+jsgyKHwzbadbx/jrTjGkrEHUlPua87Pd/APPE
 ej0PeWdGI2d6Q7Wnc6ZXw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 May 2009, Robert P. J. Day wrote:
>   shouldn't it be sufficient that, if i do another "make ??_defconfig"
> to another architecture, all traces of the previous configure are
> erased and include/asm should be relinked automatically?

In 2.6.30, the symlink is finally no longer needed, so maybe we
should simply drop it to solve this problem as well.

	Arnd <><
