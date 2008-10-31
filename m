Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbYJaKEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbYJaKEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 06:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYJaKD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 06:03:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55742 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbYJaKD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 06:03:56 -0400
Date: Fri, 31 Oct 2008 11:03:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Avoid duplicate running of pud_offset and pmd_offset
	in one_md_table_init()
Message-ID: <20081031100338.GA19981@elte.hu>
References: <490AD328.1010603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490AD328.1010603@cn.fujitsu.com>
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


* Zhaolei <zhaolei@cn.fujitsu.com> wrote:

> If !(pgd_val(*pgd) & _PAGE_PRESENT) in PAE mode, we need not get value of
> pmd_table again.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  arch/x86/mm/init_32.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

applied to tip/x86/cleanups, thanks!

	Ingo
