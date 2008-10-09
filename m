Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbYJITyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbYJITyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbYJITyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:54:36 -0400
Received: from www.tglx.de ([62.245.132.106]:52461 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbYJITyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:54:36 -0400
Date: Thu, 9 Oct 2008 21:53:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Hansen <x@jeffhansen.com>
cc: Chris Snook <csnook@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] Re: x86_32 tsc/pit and hrtimers
In-Reply-To: <Pine.LNX.4.64.0810091344250.24851@ren>
Message-ID: <alpine.LFD.2.00.0810092152410.3271@apollo>
References: <Pine.LNX.4.64.0810071640110.25661@ren> <48ECFEDC.90305@redhat.com> <Pine.LNX.4.64.0810081342570.11108@ren> <48ED1728.5060708@redhat.com> <Pine.LNX.4.64.0810081542300.14815@ren> <48ED2A89.3000902@redhat.com> <Pine.LNX.4.64.0810081554380.14982@ren>
 <alpine.LFD.2.00.0810090910510.3237@apollo> <48EE4FC4.7070902@redhat.com> <alpine.LFD.2.00.0810092118100.3271@apollo> <Pine.LNX.4.64.0810091344250.24851@ren>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2008, Jeff Hansen wrote:

> OK, so are we all agreed that something like clocksource_trust=tsc would be
> the best?

No, it's per affected device: tsc=trust or tsc=stable or whatever
unintuitive name we want to come up. And it is a modification to TSC
not to the clocksource layer.

Thanks,

	tglx
