Return-Path: <linux-kernel-owner+w=401wt.eu-S1758983AbYH3JUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983AbYH3JUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 05:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbYH3JUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 05:20:08 -0400
Received: from smtpauth.hypersurf.com ([209.237.0.8]:52385 "EHLO
	smtpauth.hypersurf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYH3JUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 05:20:07 -0400
Message-ID: <48B9106C.4000305@hypersurf.com>
Date: Sat, 30 Aug 2008 02:18:36 -0700
From: Kevin Diggs <kevdig@hypersurf.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i486; en-US; rv:1.8b2) Gecko/20050724
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] Add a cpufreq driver for the IBM PowerPC 750GX
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set adds a cpufreq driver for the IBM PowerPC 750GX processor. It
"should" also work for the 750FX. The patches are:

	1) Add low level PLL config register interface module
	2) Add cpufreq driver for the 750GX
	3) Other PowerPC kernel changes necessary to support the above
	4) Add kernel doc for the completion feature, fix split-man.pl in
	   kernel-doc-nano-HOWTO.txt
	5) Add pll script to interface with pll_if sysfs attribute

These changes are against 2.6.26.

Thanks for all who took the time to review v1!

Documentation/DocBook/Makefile            |    2
Documentation/DocBook/cf750gx.tmpl        |  441 ++++++++++++++++
Documentation/cpu-freq/pll.pl             |  773 ++++++++++++++++++++++++++++
Documentation/kernel-doc-nano-HOWTO.txt   |    4
arch/powerpc/kernel/Makefile              |    1
arch/powerpc/kernel/cpu/Makefile          |    6
arch/powerpc/kernel/cpu/cpufreq/Kconfig   |   33 +
arch/powerpc/kernel/cpu/cpufreq/Makefile  |    1
arch/powerpc/kernel/cpu/cpufreq/cf750gx.c |  741 +++++++++++++++++++++++++++
arch/powerpc/kernel/cpu/pll_if.c          |  807 ++++++++++++++++++++++++++++++
arch/powerpc/kernel/cpu_setup_6xx.S       |   13
arch/powerpc/kernel/cputable.c            |   32 +
arch/powerpc/kernel/idle_6xx.S            |   28 -
arch/powerpc/platforms/Kconfig            |    2
arch/powerpc/platforms/Kconfig.cputype    |   30 +
arch/powerpc/platforms/powermac/feature.c |    9
include/asm-powerpc/cputable.h            |    3
include/asm-powerpc/pll.h                 |  209 +++++++
include/asm-powerpc/pll_if.h              |  117 ++++
include/linux/completion.h                |   41 +
kernel/sched.c                            |   56 ++
21 files changed, 3305 insertions(+), 44 deletions(-)

Ooops, left out the diffstat.

kevin
