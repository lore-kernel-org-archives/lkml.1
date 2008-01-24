Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbYAXVCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbYAXVCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbYAXVCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:02:35 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:14930 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbYAXVCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:02:34 -0500
Date: Thu, 24 Jan 2008 13:00:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 03/26] Move Kconfig.instrumentation to arch/Kconfig and
 init/Kconfig
Message-Id: <20080124130051.ec521347.randy.dunlap@oracle.com>
In-Reply-To: <20080124203333.499728934@polymtl.ca>
References: <20080124202706.250598537@polymtl.ca>
	<20080124203333.499728934@polymtl.ca>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

On Thu, 24 Jan 2008 15:27:09 -0500 Mathieu Desnoyers wrote:

> Move the instrumentation Kconfig to
> 
> arch/Kconfig for architecture dependent options
>   - oprofile
>   - kprobes
> 
> and
> 
> init/Kconfig for architecture independent options
>   - profiling
>   - markers
> 
> Remove the "Instrumentation Support" menu. Everything moves to "General setup".

Was this done based on a suggestion from someone (Linus)?
I prefer an Instrumentation menu, but whatever...


> Delete the kernel/Kconfig.instrumentation file.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/Kconfig                   |   28 ++++++++++++++++++++
>  arch/alpha/Kconfig             |    2 -
>  arch/arm/Kconfig               |    2 -
>  arch/blackfin/Kconfig          |    2 -
>  arch/cris/Kconfig              |    2 -
>  arch/frv/Kconfig               |    2 -
>  arch/h8300/Kconfig             |    2 -
>  arch/ia64/Kconfig              |    2 -
>  arch/m32r/Kconfig              |    2 -
>  arch/m68k/Kconfig              |    2 -
>  arch/m68knommu/Kconfig         |    2 -
>  arch/mips/Kconfig              |    2 -
>  arch/parisc/Kconfig            |    2 -
>  arch/powerpc/Kconfig           |    2 -
>  arch/ppc/Kconfig               |    2 -
>  arch/s390/Kconfig              |    2 -
>  arch/sh/Kconfig                |    2 -
>  arch/sh64/Kconfig              |    2 -
>  arch/sparc/Kconfig             |    2 -
>  arch/sparc64/Kconfig           |    2 -
>  arch/um/Kconfig                |    2 -
>  arch/v850/Kconfig              |    2 -
>  arch/x86/Kconfig               |    2 -
>  arch/xtensa/Kconfig            |    2 -
>  init/Kconfig                   |   12 ++++++++
>  kernel/Kconfig.instrumentation |   55 -----------------------------------------
>  26 files changed, 40 insertions(+), 101 deletions(-)

---
~Randy
