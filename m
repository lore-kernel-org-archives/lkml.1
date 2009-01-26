Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869AbZAZGPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbZAZGPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 01:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZAZGPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 01:15:00 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:43753 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbZAZGPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 01:15:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UOROPi/p1f/wf7FkKgh9vRlpbx0oFJ/QTbP2VgcnTfNM37+FkrI3lphx4RenFea+ap
         +/rr6+rbOqpSntJRzsX8B8E+Mv+iAiVxZBDlTJkg6rxTAk4AZ+QnOaZ/Oe4sGlEiaqDE
         9KSAFZD5RHXivxKHERyvXaP8wk9CddJy8k6io=
MIME-Version: 1.0
Date: Mon, 26 Jan 2009 01:14:59 -0500
Message-ID: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
Subject: [PATCH 0/12] Next batch of x86 percpu changes
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on tip/core/percpu.  The first few patches move code out of
setup_percpu.c that should be elsewhere.  The rest are cleanups, and
making Voyager use the same per-cpu setup code as all other x86
platforms.

 arch/x86/Kconfig                    |    2 +-
 arch/x86/include/asm/cpumask.h      |    4 +
 arch/x86/include/asm/processor.h    |    9 -
 arch/x86/include/asm/topology.h     |    6 +
 arch/x86/kernel/Makefile            |    6 +-
 arch/x86/kernel/apic.c              |   18 ++
 arch/x86/kernel/cpu/common.c        |   24 ++-
 arch/x86/kernel/setup_percpu.c      |  371 +++++------------------------------
 arch/x86/kernel/smpboot.c           |    4 -
 arch/x86/kernel/smpcommon.c         |   32 ---
 arch/x86/mach-voyager/voyager_smp.c |    5 -
 arch/x86/mm/numa_64.c               |  217 ++++++++++++++++++++
 arch/x86/xen/smp.c                  |    1 -

--
Brian Gerst
