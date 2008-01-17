Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYAQT16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYAQT16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYAQT1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:27:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49259 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbYAQT1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:27:49 -0500
Date: Thu, 17 Jan 2008 11:27:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, linuxppc-dev@ozlabs.org
Subject: Re: 2.6.24-rc8-mm1: powerpc: include/asm/nvram.h:62: error: field
 'partition' has incomplete type
Message-Id: <20080117112755.896f2c74.akpm@linux-foundation.org>
In-Reply-To: <200801171918.09645.m.kozlowski@tuxland.pl>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<200801171918.09645.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 19:18:07 +0100 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

>   CC [M]  sound/ppc/awacs.o
> In file included from sound/ppc/awacs.c:24:
> include/asm/nvram.h:62: error: field 'partition' has incomplete type
> make[1]: *** [sound/ppc/awacs.o] Error 1
> make: *** [sound/ppc/awacs.o] Error 2

hm.

--- a/include/asm-powerpc/nvram.h~include-asm-powerpc-nvramh-needs-listh
+++ a/include/asm-powerpc/nvram.h
@@ -11,6 +11,7 @@
 #define _ASM_POWERPC_NVRAM_H
 
 #include <linux/errno.h>
+#include <linux/list.h>
 
 #define NVRW_CNT 0x20
 #define NVRAM_HEADER_LEN 16 /* sizeof(struct nvram_header) */
_

I wonder why mainline isn't busted actually.


