Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbYFSMN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbYFSMN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbYFSMNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:13:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34267 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899AbYFSMNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:13:20 -0400
Date: Thu, 19 Jun 2008 14:13:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: update mptable fix with no ioapic v2
Message-ID: <20080619121300.GD7640@elte.hu>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200806011317.38622.yhlu.kernel@gmail.com> <200806181432.57204.yhlu.kernel@gmail.com> <200806181729.31464.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806181729.31464.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> if the system doesn't have ioapic, we don't need to store entries for 
> mptable update
> 
> also let mp_config_acpi_gsi not call func in mpparse so later could 
> decouple mpparse with acpi more easily
> 
> Reported-by: Daniel Exner <dex@dragonslave.de>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied to tip/x86/mpparse - thanks Yinghai.

	Ingo
