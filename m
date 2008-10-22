Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYJVO0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYJVO0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYJVO01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:26:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60831 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbYJVO00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:26:26 -0400
Date: Wed, 22 Oct 2008 16:26:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Cliff Wickman <cpw@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/tlb_uv: remove strange mc146818rtc include
Message-ID: <20081022142610.GB20203@elte.hu>
References: <48F574FF.2040600@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F574FF.2040600@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0323]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> For some reason tlb_uv was including linux/mc146818rtc.h.  It really
> just needs linux/seq_file.h
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citix.com>
> Cc: Cliff Wickman <cpw@sgi.com>
> ---
> arch/x86/kernel/tlb_uv.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

applied to tip/x86/urgent, thanks Jeremy!

	Ingo
