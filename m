Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbZBZNmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbZBZNmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZBZNmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:42:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:50293 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbZBZNmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:42:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perfcounters: fix a few minor cleanliness issues
Date: Thu, 26 Feb 2009 14:42:02 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <18854.33125.115592.732783@cargo.ozlabs.ibm.com>
In-Reply-To: <18854.33125.115592.732783@cargo.ozlabs.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902261442.02519.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/oOq3qHEGMw4kmwsBfaFXZ9J0xGEDnLVQYBcR
 aGpDVUOmSaYsn7PIccqhnDm2ntIQxCX/xhwQHotPB8VME7pket
 eQ87JMQvXQJpxYDzp56uQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Paul Mackerras wrote:
> This fixes three issues noticed by Arnd Bergmann:
> 
> - Add #ifdef __KERNEL__ and move some things around in perf_counter.h
>   to make sure only the bits that userspace needs are exported to
>   userspace.
> 
> - Use __u64, __s64, __u32 types in the structs exported to userspace
>   rather than u64, s64, u32.
> 
> - Make the sys_perf_counter_open syscall available to the SPUs on
>   Cell platforms.
> 
> And one issue that I noticed in looking at the code again:
> 
> - Wrap the perf_counter_open syscall with SYSCALL_DEFINE4 so we get
>   the proper handling of int arguments on ppc64 (and some other 64-bit
>   architectures).
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Paul Mackerras <paulus@samba.org>

Thanks for the follow-up!

Acked-by: Arnd Bergmann <arnd@arndb.de>
