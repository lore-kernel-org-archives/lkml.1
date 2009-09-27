Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbZI0Kys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbZI0Kys (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 06:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZI0Kys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 06:54:48 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:48244 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbZI0Kyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 06:54:47 -0400
Date: Sun, 27 Sep 2009 06:54:50 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen Developer List <xen-devel@lists.xensource.com>
Subject: [PATCH] XEN:  Fix comment spelling:  CPU_HOTPLUG -> HOTPLUG_CPU
Message-ID: <alpine.LFD.2.00.0909270652030.18122@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The correct CONFIG variable name is "HOTPLUG_CPU".

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index fe03eee..aeb84f7 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -359,7 +359,7 @@ static void xen_cpu_die(unsigned int cpu)
 		alternatives_smp_switch(0);
 }

-static void __cpuinit xen_play_dead(void) /* used only with CPU_HOTPLUG */
+static void __cpuinit xen_play_dead(void) /* used only with HOTPLUG_CPU */
 {
 	play_dead_common();
 	HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
