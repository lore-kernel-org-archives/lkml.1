Return-Path: <linux-kernel-owner+w=401wt.eu-S1757683AbYHGWKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbYHGWKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYHGWKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:10:33 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14941 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbYHGWKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:10:32 -0400
Date: Thu, 7 Aug 2008 15:07:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Cliff Wickman <cpw@sgi.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 7 (SGI UV)
Message-Id: <20080807150750.162f816c.randy.dunlap@oracle.com>
In-Reply-To: <20080807172027.8180312c.sfr@canb.auug.org.au>
References: <20080807172027.8180312c.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This may happen in mainline, but I haven't checked there.)

sparse complains about bitfields not being marked as signed or unsigned
and about one-bit bitfields being (default) signed (sign bit only!):

  CHECK   /local/linsrc/linux-next-20080807/arch/x86/kernel/tlb_64.c
include2/asm/uv/uv_bau.h:141:22: warning: dubious bitfield without explicit `signed' or `unsigned'
include2/asm/uv/uv_bau.h:143:25: warning: dubious bitfield without explicit `signed' or `unsigned'
include2/asm/uv/uv_bau.h:145:15: warning: dubious bitfield without explicit `signed' or `unsigned'
include2/asm/uv/uv_bau.h:148:14: warning: dubious bitfield without explicit `signed' or `unsigned'
include2/asm/uv/uv_bau.h:151:14: warning: dubious bitfield without explicit `signed' or `unsigned'
include2/asm/uv/uv_bau.h:154:18: warning: dubious bitfield without explicit `signed' or `unsigned'
include2/asm/uv/uv_bau.h:156:18: warning: dubious bitfield without explicit `signed' or `unsigned'
include2/asm/uv/uv_bau.h:160:14: error: dubious one-bit signed bitfield
include2/asm/uv/uv_bau.h:164:18: error: dubious one-bit signed bitfield
include2/asm/uv/uv_bau.h:178:19: error: dubious one-bit signed bitfield
include2/asm/uv/uv_bau.h:186:16: error: dubious one-bit signed bitfield
include2/asm/uv/uv_bau.h:190:18: error: dubious one-bit signed bitfield
include2/asm/uv/uv_bau.h:193:16: error: dubious one-bit signed bitfield
  CC      arch/x86/kernel/tlb_64.o


Can those struct bitfields be marked as signed or unsigned, please?

Thanks.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
