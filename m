Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbYHHMRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbYHHMRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 08:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbYHHMRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 08:17:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:53512 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbYHHMRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 08:17:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 4/4] introduce sys_checkpoint and sys_restore
Date: Fri, 8 Aug 2008 14:15:18 +0200
User-Agent: KMail/1.9.9
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
       "Serge E. Hallyn" <serue@us.ibm.com>
References: <20080807224033.FFB3A2C1@kernel> <20080807224038.0B03CEEF@kernel>
In-Reply-To: <20080807224038.0B03CEEF@kernel>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081415.19179.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/cz8QX88uDl6jaOpQdiqxpXGSN+e0YId7issg
 PhwP9hpIhDO+OLs4vzPpzAmsBHUDHJVfAASqkqgxdMmdvLbxiJ
 JYgmGVQuBSFI9DHPmjGZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 August 2008, Dave Hansen wrote:
>
>  linux-2.6.git-dave/arch/x86/kernel/syscall_table_32.S |    2 ++
>  linux-2.6.git-dave/include/asm-x86/unistd_32.h        |    2 ++
>  2 files changed, 4 insertions(+)

System calls should also be declared in include/linux/syscalls.h.

I guess you are aware that this implementation is not enough to
support 32 bit tasks on x86_64. In addition to the native 64-bit
code, you would also need the 32-bit compat code here.

	Arnd <><
