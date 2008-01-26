Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbYAZV7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbYAZV7n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 16:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbYAZV7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 16:59:34 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40515 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbYAZV7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 16:59:34 -0500
Date: Sat, 26 Jan 2008 22:59:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/8] x86: fix section mismatch warnings
Message-ID: <20080126215917.GB26651@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following serie of 8 patches contains:

x86: fix Section mismatch warning in srat_64.c
=> straightforward - please apply

x86: fix Section mismatch warning in mcheck/mce_64.c
=> I took some assumptions on use of notifier.
   See comments and please review before applying

x86: fix Section mismatch warning in mcheck/mce_amd_64.c
=> Same comments as for previous patch

x86: fix Section mismatch warning in topology.c
=> Straightforward - please apply.
   I made EXPORT of arch_register_cpu independent on config in this patch
   as I do not see why we want to do otherwise.

x86: fix Section mismatch warning in process_*.c
=> Strightforward - please apply

x86: fix Section mismatch warning in acpi/boot.c
=> Strightforward - please apply

x86: fix Section mismatch warning in early-quirks.c
=> Strightforward - please apply

x86: fix Section mismatch warning in setup_64.c
=> Strightforward - please apply


All warnigns were generated with a 64 bit defconfig with
latest kbuild.git patches applied.
You should not expect to see identical warnings neither
the same amount of them.

There are a few warnings left but they await any feedback
on the __ref annotation before I address these.
And they will likely depens on having kbuild.git
applied.

So the remaining warnings in arch/x86/ will not
be addressed until both kbuild.git and x86.git has been merged.

Patches follows unnumbered as they are independent.

	Sam
