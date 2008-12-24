Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbYLXUiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbYLXUiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 15:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYLXUiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 15:38:00 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:43074 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750993AbYLXUh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 15:37:59 -0500
Date: Thu, 25 Dec 2008 07:37:47 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Patrick McHardy <kaber@trash.net>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: asterisk hangs with RT priority
Message-ID: <20081224203747.GA32060@gondor.apana.org.au>
References: <483054DB.4030504@trash.net> <20081224113617.GA29037@gondor.apana.org.au> <20081224134225.GA4666@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224134225.GA4666@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2008 at 07:12:25PM +0530, Dhaval Giani wrote:
> 
> Hmm. Do you have CONFIG_FAIR_USER_SCHED set on?

I can't find such a config option, but

$ grep SCHED .config
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=m
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=m
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
CONFIG_SCHED_HRTICK=y
CONFIG_NET_SCHED=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
$ 

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
