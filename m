Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbXIRSi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbXIRSi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbXIRSiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:38:19 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61797 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbXIRSiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:38:18 -0400
Date: Tue, 18 Sep 2007 11:37:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Combine instrumentation menus in
 kernel/Kconfig.instrumentation
Message-Id: <20070918113728.a0f38a3c.randy.dunlap@oracle.com>
In-Reply-To: <20070917184552.GA5356@Krystal>
References: <20070917184552.GA5356@Krystal>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 14:45:52 -0400 Mathieu Desnoyers wrote:

> Combine instrumentation menus in kernel/Kconfig.instrumentation

Thanks, looks very good.

> Quoting Randy:
> 
> "It seems sad that this patch sources Kconfig.marker, a 7-line file,
> 20-something times.  Yes, you (we) don't want to put those 7 lines
> into 20-something different files, so sourcing is the right thing.
> 
> However, what you did for avr32 seems more on the right track to me:
> make _one_ Instrumentation support menu that includes PROFILING,
> OPROFILE, KPROBES, and MARKERS and then use (source) that in all
> of the arches."
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Randy Dunlap <randy.dunlap@oracle.com>

Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>
or
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
>  arch/alpha/Kconfig             |    2 -
>  arch/alpha/oprofile/Kconfig    |   23 ----------------------
>  arch/arm/Kconfig               |    2 -
>  arch/arm/oprofile/Kconfig      |   42 -----------------------------------------
>  arch/blackfin/Kconfig          |    2 -
>  arch/blackfin/oprofile/Kconfig |   29 ----------------------------
>  arch/cris/Kconfig              |    2 +
>  arch/frv/Kconfig               |    2 +
>  arch/h8300/Kconfig             |    2 +
>  arch/i386/Kconfig              |   25 ------------------------
>  arch/i386/oprofile/Kconfig     |   17 ----------------
>  arch/ia64/Kconfig              |   15 --------------
>  arch/ia64/oprofile/Kconfig     |   20 -------------------
>  arch/m32r/Kconfig              |    2 -
>  arch/m32r/oprofile/Kconfig     |   23 ----------------------
>  arch/m68k/Kconfig              |    2 +
>  arch/m68knommu/Kconfig         |    2 +
>  arch/mips/Kconfig              |    2 -
>  arch/mips/oprofile/Kconfig     |   23 ----------------------
>  arch/parisc/Kconfig            |    2 -
>  arch/parisc/oprofile/Kconfig   |   23 ----------------------
>  arch/powerpc/Kconfig           |   15 --------------
>  arch/powerpc/oprofile/Kconfig  |   24 -----------------------
>  arch/ppc/Kconfig               |    2 -
>  arch/s390/Kconfig              |   16 ---------------
>  arch/s390/oprofile/Kconfig     |   22 ---------------------
>  arch/sh/Kconfig                |    2 -
>  arch/sh/oprofile/Kconfig       |   23 ----------------------
>  arch/sh64/Kconfig              |    2 -
>  arch/sh64/oprofile/Kconfig     |   23 ----------------------
>  arch/sparc/Kconfig             |    6 -----
>  arch/sparc/oprofile/Kconfig    |   17 ----------------
>  arch/sparc64/Kconfig           |   15 --------------
>  arch/sparc64/oprofile/Kconfig  |   17 ----------------
>  arch/um/Kconfig                |    2 +
>  arch/v850/Kconfig              |    2 +
>  arch/x86_64/Kconfig            |   15 --------------
>  arch/x86_64/oprofile/Kconfig   |   17 ----------------
>  arch/xtensa/Kconfig            |    2 +
>  kernel/Kconfig.instrumentation |   40 +++++++++++++++++++++++++++++++++++++++
>  40 files changed, 72 insertions(+), 452 deletions(-)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
