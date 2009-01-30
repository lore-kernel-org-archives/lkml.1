Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZA3SFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZA3SFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 13:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZA3SFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 13:05:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62156 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbZA3SFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 13:05:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Narendra Prasad Madanapalli <narendramind@gmail.com>
Subject: Re: [PATCH 1/1] x86: syscalls: sys_setrlimit64/sys_getrlimit64 calls  to provide FSIZE limits > 2^32-1
Date: Fri, 30 Jan 2009 19:04:51 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       torvalds@osdl.org, linux-api@vger.kernel.org,
       mtk.manpages@googlemail.com
References: <200901231759.n0NHxKA3009104@eng-pool-55.spikesource.com> <497E595F.2010708@gmail.com> <85e5430e0901300957x64951d6at2a79c5cb1ee88e97@mail.gmail.com>
In-Reply-To: <85e5430e0901300957x64951d6at2a79c5cb1ee88e97@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301904.52328.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ENRlVDvO742M0xZd2T93EMLl/bZbjB1KJ5xN
 CGCs+2fe13U5GuHhNT6u//aYjcR9O4bCu27BJFcMBJ/BjIoHWp
 143uSjyVYINqQpOJ0IG0w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009, Narendra Prasad Madanapalli wrote:
> Can you provide me more information on how to port these system calls
> to 32-on-64 kernel.

Your interface has compatible calling conventions between 32 and 64
bit user programs, so for x86, all you need to do is to add them to
arch/x86/ia32/ia32entry.S in the same way as you did for
arch/x86/kernel/syscall_table_32.S.
For the other architectures, the respective maintainers will take
care of this if your patch gets accepted. Unfortunately, each
architecture has a different way of adding the compat system
calls.

	Arnd <><
