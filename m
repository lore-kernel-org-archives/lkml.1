Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYHMF4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYHMF4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 01:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYHMF40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 01:56:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784AbYHMF40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 01:56:26 -0400
Date: Tue, 12 Aug 2008 22:56:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/22] x86: use the new byteorder headers
Message-Id: <20080812225612.6742aaf0.akpm@linux-foundation.org>
In-Reply-To: <1218587234.30194.93.camel@brick>
References: <1218587234.30194.93.camel@brick>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


akpm2:/usr/src/25> make arch/x86/boot/memory.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/asm/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      arch/x86/boot/memory.o
In file included from include/asm-generic/bitops/le.h:5,
                 from include/asm-generic/bitops/ext2-non-atomic.h:4,
                 from include/asm/bitops.h:451,
                 from include/linux/bitops.h:17,
                 from include/linux/kernel.h:15,
                 from arch/x86/boot/memory.c:16:
include/asm/byteorder.h: In function '__arch_swab64':
include/asm/byteorder.h:47: warning: implicit declaration of function '___arch__swab32'

I'll drop them all.  Do you have a cross-compiler suite there?
