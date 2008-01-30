Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbYA3AiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbYA3AiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYA3Ahu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:37:50 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:55646 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbYA3Aht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:37:49 -0500
Date: Wed, 30 Jan 2008 01:37:48 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Mike Frysinger <vapier@gentoo.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] linux/types.h: always export 64bit aligned defines
In-Reply-To: <200801291916.21133.vapier@gentoo.org>
Message-ID: <Pine.LNX.4.64.0801300136430.14907@fbirervta.pbzchgretzou.qr>
References: <200801260423.21860.vapier@gentoo.org>
 <20080127213319.01026b19.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0801292030190.14907@fbirervta.pbzchgretzou.qr>
 <200801291916.21133.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 29 2008 19:16, Mike Frysinger wrote:
>> >> Some kernel headers exported to userspace rely on these 64bit
>> >> aligned defines. However, they are hidden behind
>> >> __KERNEL_STRICT_NAMES at the moment which means most of the time,
>> >> they're never actually available.
>>
>> Wrong way.
>
>i'm thinking the right way, i just may not have expressed it completely 
>clearly ...
>
>> They are inside #ifndef __KERNEL_STRICT_NAMES, so 
>> they _are_ available to userspace.
>
>for all practical purposes, they are not.  glibc will define 
>__KERNEL_STRICT_NAMES because (like a sane C lib), it defines all of the 
>basic types that the kernel also defines.

Phew - now we have two sorts of userspace? (Those with glibc and
those without, aka standalone). Right, it's messy, which is why
this thread exists and a better solution is sought :)
