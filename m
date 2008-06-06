Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbYFFC2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbYFFC2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 22:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYFFC1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 22:27:52 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64129 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753571AbYFFC1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 22:27:52 -0400
Date: Fri, 6 Jun 2008 03:27:02 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] x86: NMI watchdog downgrade changes
Message-ID: <Pine.LNX.4.55.0806060311510.2875@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

 This is a series of patches in response to your earlier report to fix the
problem where the I/O APIC NMI watchdog is attempted where it should not
be, fails and then disables the timer leading the system to a fatal
failure.  Please put in tip/x86/apic, replacing the patch named
nosmp-watchdog or 'x86: APIC/SMP: Downgrade the NMI watchdog for "nosmp"'
in the sequence.

  Maciej
