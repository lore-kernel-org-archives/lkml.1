Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbZCVWk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbZCVWk6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 18:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbZCVWks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 18:40:48 -0400
Received: from bu3sch.de ([62.75.166.246]:42294 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbZCVWkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 18:40:47 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Date: Sun, 22 Mar 2009 23:38:53 +0100
User-Agent: KMail/1.9.9
Cc: Rui Santos <rsantos@grupopie.com>,
       Michael =?iso-8859-1?q?B=C3=83=C2=BCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org
References: <200903041828.49972.m.bueker@berlin.de> <200903222309.58116.mb@bu3sch.de> <20090322222732.GA25563@electric-eye.fr.zoreil.com>
In-Reply-To: <20090322222732.GA25563@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903222338.53223.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 March 2009 23:27:32 Francois Romieu wrote:
> Michael Buesch <mb@bu3sch.de> :
> [...]
> > How do I find out? I don't find "XID" in the kernel log.
> 
> Check the log level ?
> 
> [...]
> r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> r8169 0000:00:0a.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> r8169 0000:00:0a.0: no PCI Express capability
> eth2: RTL8110s at 0xf8992400, 00:09:5b:bc:e9:9e, XID 04000000 IRQ 17
> 

Ok, it scrolled out of the buffer due to massive warnings from all over
the kernel (there also are unrelated problems elsewhere).
:)

Mar 13 12:38:07 quimby kernel: [    0.723831] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
Mar 13 12:38:07 quimby kernel: [    0.723912] r8169 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Mar 13 12:38:07 quimby kernel: [    0.723978] r8169 0000:01:00.0: setting latency timer to 64
Mar 13 12:38:07 quimby kernel: [    0.724073] r8169 0000:01:00.0: irq 383 for MSI/MSI-X
Mar 13 12:38:07 quimby kernel: [    0.724305] eth0: RTL8168c/8111c at 0xffffc20000542000, 00:1c:c0:8d:2b:47, XID 3c4000c0 IRQ 383


-- 
Greetings, Michael.
