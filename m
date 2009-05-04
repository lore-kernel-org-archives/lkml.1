Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbZEDKcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbZEDKcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 06:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZEDKcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 06:32:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63258 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbZEDKcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 06:32:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH V3] asm-generic: add a generic uaccess.h
Date: Mon, 4 May 2009 12:32:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org, Russell King <rmk+lkml@arm.linux.org.uk>
References: <cover.1241105648.git.arnd@arndb.de> <200905011513.25344.arnd@arndb.de> <49FE861D.5050808@monstr.eu>
In-Reply-To: <49FE861D.5050808@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905041232.22732.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18fY+vpXoP1pjGyJf/s2VDOjDpnSlo3wWVFVdF
 sdUB4nVI/zhvp/TfHoodU38yfiBNeNEOlU6OfjkWzS02XFoI4t
 TLbpU3FFtdQrfUSXgO8qA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 May 2009, Michal Simek wrote:
> #define MAKE_MM_SEG(s)  ((mm_segment_t) { (s) })
> 
> #ifndef KERNEL_DS
> #define KERNEL_DS       MAKE_MM_SEG(~0UL)
> #endif
> 
> #ifndef USER_DS
> #define USER_DS         MAKE_MM_SEG(TASK_SIZE - 1)
> #endif
> 
> 
> #ifndef get_fs
> #define get_ds() (KERNEL_DS)
> #define get_fs() (current_thread_info()->addr_limit)
> 
> static inline void set_fs(mm_segment_t fs)
> {
>         current_thread_info()->addr_limit = fs;
> }
> #endif
> 

yes, looks good. Thanks for the suggestion.

	Arnd <><
