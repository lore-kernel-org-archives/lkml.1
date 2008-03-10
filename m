Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbYCJLYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbYCJLYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 07:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYCJLXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 07:23:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:59144 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbYCJLXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 07:23:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] kvm: provide kvm.h for all architecture: fixes headers_install
Date: Mon, 10 Mar 2008 12:23:02 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Avi Kivity <avi@qumranet.com>,
       Sam Ravnborg <sam@ravnborg.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <200803071326.06682.borntraeger@de.ibm.com> <1204933418.2495.14.camel@shinybook.infradead.org> <200803100913.46422.borntraeger@de.ibm.com>
In-Reply-To: <200803100913.46422.borntraeger@de.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803101223.03712.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1++YfmfaROWHFwR8W3Gr6PuO87WgOw3CjOK72v
 0UCc2dKZw47mO23EEs10mDw1Jmq9vqV1BPghWa3VJ6k1O0vLSX
 2LO+OW2qJGE/IOsOEZB6w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2008, Christian Borntraeger wrote:
>  include/asm-alpha/Kbuild     |    1 +
>  include/asm-alpha/kvm.h      |    6 ++++++
>  include/asm-arm/Kbuild       |    2 ++
>  include/asm-arm/kvm.h        |    6 ++++++
>  include/asm-avr32/Kbuild     |    1 +
>  include/asm-avr32/kvm.h      |    6 ++++++
>  include/asm-blackfin/Kbuild  |    1 +
>  include/asm-blackfin/kvm.h   |    6 ++++++
>  include/asm-cris/Kbuild      |    1 +
>  include/asm-cris/kvm.h       |    6 ++++++
>  include/asm-frv/Kbuild       |    1 +
>  include/asm-frv/kvm.h        |    6 ++++++
>  include/asm-h8300/Kbuild     |    2 ++
>  include/asm-h8300/kvm.h      |    6 ++++++
>  include/asm-ia64/Kbuild      |    1 +
>  include/asm-ia64/kvm.h       |    6 ++++++
>  include/asm-m32r/Kbuild      |    2 ++
>  include/asm-m32r/kvm.h       |    6 ++++++
>  include/asm-m68k/Kbuild      |    1 +
>  include/asm-m68k/kvm.h       |    6 ++++++

Instead of adding kvm.h to every single Kbuild file, you can
just add it once, in include/asm-generic/Kbuild.asm.

	Arnd <><
