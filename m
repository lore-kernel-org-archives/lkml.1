Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbZBDQiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbZBDQiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZBDQiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:38:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:49250 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbZBDQiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:38:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
Date: Wed, 4 Feb 2009 17:37:56 +0100
User-Agent: KMail/1.9.9
Cc: Avi Kivity <avi@redhat.com>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <1232287474.3130.19.camel@localhost.localdomain> <4989B6F7.4060004@redhat.com> <1233763212.3523.5.camel@localhost.localdomain>
In-Reply-To: <1233763212.3523.5.camel@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041737.57453.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+D+shPTkHuQ09psdd1x5qP6YoJIOfP1fe+5jW
 3mjKMSbZjwtr2PQVp3FTNzVA8NY41TQH4yOW7VBnia8TriEjGr
 t4Gn8kBHavjgxKJBQtpSQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Jaswinder Singh Rajput wrote:
> On Wed, 2009-02-04 at 17:40 +0200, Avi Kivity wrote:
> > If there's such a patch in the URL you posted, please point to it directly.
> > 
> All CONFIG_* patches are dropped.

Well, the kvm.h patch was one of two that AFAICT are actually needed:
If you don't define CONFIG_X86 or CONFIG_IA64 in user space, you
won't see the definitions for kvm_irqchip->pic, kvm_irqchip->ioapic
or KVM_CAP_{DEVICE_ASSIGNMENT,DEVICE_MSI,USER_MSI}.

The other patch that we still need is the one I posted for
asm/ptrace-abi.h.

	Arnd <><
