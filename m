Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbYGJRRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbYGJRRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYGJRRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:17:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44507 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbYGJRRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:17:35 -0400
Date: Thu, 10 Jul 2008 19:17:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] x86/pci: patches for tip/x86/unify-pci
Message-ID: <20080710171721.GA19737@elte.hu>
References: <1215709106-9182-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215709106-9182-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> This patch series contains patches for tip/x86/unify-pci. It fixes 
> NUMA initialization code reflecting latest changes in tip/master. Also 
> there are build fixes and minor cleanups. Patch #5 is a cherry pick 
> that fixes build on UP systems. Code reboots for smp/nosmp, 
> acpi/noacpi, numaq, 32/64bit. It compiles for visws.

thanks Robert. Today i've eliminated the VISWS subarch which greatly 
simplified your series. I've picked up these two fixes:

 Robert Richter (2):
       x86/pci merge: fixing numaq initialization
       x86/pci: fix warnings in subsys_initcall functions

the others were moot i think.

Please check the tip/x86/generalize-visws, i just pushed them all out.

	Ingo
