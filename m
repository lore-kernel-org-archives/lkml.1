Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYHRQqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYHRQqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbYHRQpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:45:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:27999 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbYHRQps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=AUBD+oj23IhxeZFmFI3B20mDhuwqQFb/DVu3ZB62ISlNC57L1TFZWBAKi3Buib+czb
         vc9dm20x53261maoLYw+Usd+uPL5nmffdSb26xdEC2NrZhpkRCW4D7umM63Be1Jtry4v
         u8JAwUwnbpKKr+sv/CK2NJEEZ3Aps1x7daqMw=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH 0/15] apic: unification series 5
Date: Mon, 18 Aug 2008 20:45:48 +0400
Message-Id: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series is over

commit d5e629a6f88137fb77c4cc857be5ea7c3f27110d
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Sun Aug 17 21:12:27 2008 -0700

    x86: apic - unify lapic_resume - fix
    
    Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Please review - any comments are quite welcome!

Mostly #ifdef added, code rearrangement - nothing serious
(except new bugs have been brought in :-)

So I think the most simple/basic unification is done.
Now unif. process will be harder since it will require
for much detailed code review - for example smp_spurious_interrupt
which uses different call frames on 32/64 bit modes and will
require some wrapping I think.

With this series 32bit code compilation warns:

arch/x86/kernel/apic_32.c: In function ‘end_local_APIC_setup’:
arch/x86/kernel/apic_32.c:1165: warning: ISO C90 forbids mixed declarations and code
arch/x86/kernel/apic_32.c: In function ‘disconnect_bsp_APIC’:
arch/x86/kernel/apic_32.c:1446: warning: ISO C90 forbids mixed declarations and code
cyrill@lenovo linux-2.6.git $ 

So parenthesis will be needed to eliminate them... but
I think it could be too ugly... need some time to think.
So patches 8/15 and 10/15 sould be not applied for now - just review them.
Thanks for patience!

		- Cyrill -
