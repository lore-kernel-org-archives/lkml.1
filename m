Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbZA2UaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbZA2UaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZA2U3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:29:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41163 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbZA2U3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:29:55 -0500
Date: Thu, 29 Jan 2009 21:29:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: uaccess: fix compilation error on CONFIG_M386
Message-ID: <20090129202942.GD12819@elte.hu>
References: <4982083E.50200@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4982083E.50200@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Impact: fix compilation error
> 
> In case of !CONFIG_X86_WP_WORKS_OK, __put_user_size_ex() is not defined.
> Add macros for !CONFIG_X86_WP_WORKS_OK case.

applied to tip/x86/uaccess, thanks!

	Ingo
