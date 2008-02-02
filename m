Return-Path: <linux-kernel-owner+w=401wt.eu-S1763673AbYBBPFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763673AbYBBPFl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 10:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758509AbYBBPFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 10:05:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:48915 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758045AbYBBPFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 10:05:31 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+c0flirEScaYfOycNfjB+rgOk/Y8JfbtIZGi5cjg
	szxUJALJ75FlGx
Date: Sat, 2 Feb 2008 16:05:41 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: [X86 ACPI SMP] system slow after cold start if processor module
 loaded
Message-ID: <Pine.LNX.4.64.0802021558340.5546@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Don't know if this should be considered a bug-report, or just another ACPI 
bug on my system. In any case, if the CONFIG_ACPI_PROCESSOR is enabled, on 
first boot after a power off the system is slow. Not like if only 1 of 2 
CPUs actually was running, much slower yet. Respectively, if the module is 
built into the kernel, it is slow more or less from the beginning - I 
guess, from the moment, when the module is initialized, if built as a 
module, it is slow after the module gets loaded. Also funny, it is only 
slow on the first boot, after a reboot into the same kernel it runs 
normally. The system is a dual P-II@400MHz, Compaq AP400. It is known to 
have various ACPI bugs, so, this is just another one of them. No idea 
whether or not this shall and can be fixed. At least wanted to document it 
in case someone has a similar problem.

Thanks
Guennadi
---
Guennadi Liakhovetski
