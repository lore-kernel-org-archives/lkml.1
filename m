Return-Path: <linux-kernel-owner+w=401wt.eu-S1761841AbYFLNPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761841AbYFLNPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761699AbYFLNPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:15:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36613 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759790AbYFLNPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:15:32 -0400
Date: Thu, 12 Jun 2008 15:15:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: touch_nmi_watchdog - reset alert counters for
	supported nmi_watchdog modes only
Message-ID: <20080612131515.GA12435@elte.hu>
References: <20080612130816.GA7007@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612130816.GA7007@cvg>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> The checking 'if nmi_watchdog > 0' (ie NMI_NONE) is quite fast but it 
> has a side effect - it's taken even if nmi_watchdog = NMI_DISABLED.
> 
> Nowadays nmi_watchdog is set up to NMI_NONE by default so this 
> condition is properly taken most the time but we better show this 
> explicitly.

applied to tip/x86/nmi - thanks Cyrill.

	Ingo
