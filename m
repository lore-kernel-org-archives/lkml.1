Return-Path: <linux-kernel-owner+w=401wt.eu-S1761811AbXJZUYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761811AbXJZUYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbXJZUYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:24:12 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:54541 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077AbXJZUYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:24:11 -0400
Date: Fri, 26 Oct 2007 22:17:42 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Romano Giannetti <romanol@upcomillas.es>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Edward Hsu <edward_hsu@realtek.com.tw>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] r8169: don't call napi_disable if not doing NAPI
Message-ID: <20071026201742.GA29246@electric-eye.fr.zoreil.com>
References: <1193232344.32208.0.camel@localhost> <20071024142759.GA13657@elte.hu> <1193241191.14314.8.camel@localhost> <20071024155521.GA16690@elte.hu> <1193242267.6914.6.camel@twins> <1193378269.17910.4.camel@localhost> <20071026063733.GA12426@elte.hu> <20071026094833.539a69aa@freepuppy.rosehill> <20071026175613.GA18770@elte.hu> <20071026113305.57dea765@freepuppy.rosehill>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026113305.57dea765@freepuppy.rosehill>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemminger@linux-foundation.org> :
> Don't call napi_disable if not configured.
> And make sure that any misuse of napi_xxx in future fails
> with a compile error.

Disable napi polling early and remove the useless poll_locked logic.

> 
> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

Acked-off-by: Francois Romieu <romieu@fr.zoreil.com>

-- 
Ueimor
