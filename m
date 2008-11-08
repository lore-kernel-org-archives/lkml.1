Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbYKHLmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbYKHLmv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 06:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYKHLmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 06:42:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36535 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbYKHLmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 06:42:39 -0500
Date: Sat, 8 Nov 2008 12:42:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt LaPlante <kernel1@cyberdogtech.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Change default for STRICT_DEVMEM
Message-ID: <20081108114226.GB8354@elte.hu>
References: <1226089116-7700-1-git-send-email-kernel1@cyberdogtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226089116-7700-1-git-send-email-kernel1@cyberdogtech.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt LaPlante <kernel1@cyberdogtech.com> wrote:

> The recommendation for STRICT_DEVMEM is to select Y,
> however the option currently defaults to N.  Have the option
> default to Y since it is recommended.
> 
> ---
>  arch/x86/Kconfig.debug |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

no. This is a special case: due to compatibility we default to N, but 
still we recommend people/distros to enable it. Eventually we can 
switch around the default in the future, but not yet.

	Ingo
