Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbYDGIXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbYDGIXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 04:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbYDGIXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 04:23:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48932 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415AbYDGIXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 04:23:12 -0400
Date: Mon, 7 Apr 2008 10:22:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Daniel Arai <arai@vmware.com>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] Fix paranoia about using BIOS quickboot mechanism.
Message-ID: <20080407082256.GA3524@elte.hu>
References: <1207352954.6294.30.camel@promb-2n-dhcp158.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207352954.6294.30.camel@promb-2n-dhcp158.eng.vmware.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Alok Kataria <akataria@vmware.com> wrote:

> Make sure that we clear the "shutdown status flag" in the CMOS 
> register after each CPU is brought up.  This fixes a problem where the 
> "shutdown status flag" may remain set when a CPU is brought up after 
> booting.

btw., what problem does this result in, exactly?

> Tested on the X86 tree.

> + * Cleanup possible dangling ends...
> + */
> + smpboot_restore_warm_reset_vector();
> +
> return boot_error;
> }

patch got whitespace damaged - have a look at 
Documentation/email-clients.txt for details about how to send patches as 
in-line text. (or send the patch as an attachment - we accept x86 
patches as attachments too)

	Ingo
