Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYH1MMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYH1MMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 08:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYH1MMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 08:12:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39322 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYH1MMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 08:12:01 -0400
Date: Thu, 28 Aug 2008 14:14:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Message-ID: <20080828121436.GN26610@one.firstfloor.org>
References: <20080819103301.787700742@chello.nl> <alpine.LFD.1.10.0808262228030.3243@apollo.tec.linutronix.de> <874p57s873.fsf@basil.nowhere.org> <200808272008.16106.nickpiggin@yahoo.com.au> <20080828105408.GA4488@elte.hu> <20080828110923.GL26610@one.firstfloor.org> <1219922353.6443.14.camel@twins> <20080828115035.GM26610@one.firstfloor.org> <1219924853.6443.18.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219924853.6443.18.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Then people can no longer assume stuff like queue_work_on() etc.. works.
> Users of such code might depend on it actually running on the specified
> cpu.

If they assume that they're already buggy because CPU hot unplug will break
affinities.

-Andi
