Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbZJCUy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbZJCUy2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 16:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757154AbZJCUy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 16:54:27 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:25169 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786AbZJCUy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 16:54:26 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=pass (signature verified [TEST]) header.i=rdreier@cisco.com
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAANXx0qrR7PE/2dsb2JhbAC6J4hhAY5MBoQq
X-IronPort-AV: E=Sophos;i="4.44,500,1249257600"; 
   d="scan'208";a="401511389"
From: Roland Dreier <rdreier@cisco.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pavel Machek <pavel@ucw.cz>, "Wang\, Shane" <shane.wang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Cihula\, Joseph" <joseph.cihula@intel.com>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
References: <200909282307.56190.rjw@sisk.pl> <4AC1267D.6020405@zytor.com>
	<20090928211745.GA2119@elf.ucw.cz> <4AC1AA61.8070408@intel.com>
	<20090929171318.GC14405@elf.ucw.cz>
	<20090929191951.18315e94@infradead.org>
	<037F493892196B458CD3E193E8EBAD4F01ED9FE3B1@pdsmsx502.ccr.corp.intel.com>
	<20090930065448.GB11652@elf.ucw.cz>
	<037F493892196B458CD3E193E8EBAD4F01ED9FE6E3@pdsmsx502.ccr.corp.intel.com>
	<20091003201959.GA16047@elf.ucw.cz>
	<20091003203619.GA27182@khazad-dum.debian.net>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 03 Oct 2009 13:44:22 -0700
In-Reply-To: <20091003203619.GA27182@khazad-dum.debian.net> (Henrique de
	Moraes Holschuh's message of "Sat, 3 Oct 2009 17:36:20 -0300")
Message-ID: <ada4oqgp5qx.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Oct 2009 20:44:22.0576 (UTC) FILETIME=[499D7B00:01CA446A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > > So I modify the RAM content so that BIOS does not think measured
 > > > environment existed before suspend?

 > And it is ridiculously easy to pull off, too:
 > http://www.engadget.com/2008/02/21/cold-boot-disk-encryption-attack-is-shockingly-effective/
 > 
 > Shows the attack being used to read sensitive keys, but you can use it also
 > to *modify* system running state (it will be more difficult, as you need to
 > remove and replace the RAM while on S3 instead of S5, but it should be
 > doable by someone who knows what he is doing).

I believe the whole point of this TXT / S3 handling is that the resume
from S3 will then be able to detect that the contents of RAM have been
modified while the system was asleep.

TXT simply produces a reasonably trustworthy measurement of system
state.  If you modify RAM while the system is asleep, then you will not
be able to produce a measurement showing an unmodified system state.

 - R.
