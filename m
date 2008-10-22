Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbYJVORE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbYJVORE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYJVOQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:16:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56792 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbYJVOQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:16:51 -0400
Date: Wed, 22 Oct 2008 16:16:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: remove redundant KERN_DEBUG on pr_debug
Message-ID: <20081022141626.GB26372@elte.hu>
References: <1224077824-28102-1-git-send-email-gustavo@las.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224077824-28102-1-git-send-email-gustavo@las.ic.unicamp.br>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1287]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gustavo F. Padovan <gustavo@las.ic.unicamp.br> wrote:

> pr_debug don't need KERN_DEBUG.
> 
> Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
> ---
>  arch/x86/kernel/acpi/boot.c    |    2 +-
>  arch/x86/kernel/setup_percpu.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

applied, thanks Gustavo!

	Ingo
