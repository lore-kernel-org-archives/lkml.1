Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbXLUTgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbXLUTgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 14:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbXLUTgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 14:36:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:63523 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbXLUTgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 14:36:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH -mm 18/43] powerpc compat_binfmt_elf
Date: Fri, 21 Dec 2007 20:36:27 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Kyle McMartin <kyle@mcmartin.ca>, Roland McGrath <roland@redhat.com>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20071220115200.C767E26F98A@magilla.localdomain> <20071221085609.4D53B26F98A@magilla.localdomain> <20071221175106.GB17656@fattire.cabal.ca>
In-Reply-To: <20071221175106.GB17656@fattire.cabal.ca>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712212036.29098.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/8re1n586XgTlDBXGj5296Su3b+vJm/81hxhY
 z4H/9jMWhBNXV8zwOdxyQeh75BBZguszx1u2NTZHr88W2IqAHL
 qWBQRuZm6KauoEtF1RY4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2007, Kyle McMartin wrote:
> Just taking a stab that hch means,
> 
> config BINFMT_COMPAT_ELF
>         def_bool n
>         depends on 64BIT
> 

I'd call it COMPAT_BINFMT_ELF, for consistency with the file name.
Also, the definition and the depends are redundant if you expect the
option to be autoselected. You can do either of

config COMPAT_BINFMT_ELF
	bool

or 

config COMPAT_BINFMT_ELF
	def_bool y
	depends on COMPAT

The second option makes sense at the point where all architectures with
compat code are using the same compat_binfmt_elf code.

	Arnd <><
