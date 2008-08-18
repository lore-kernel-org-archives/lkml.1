Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbYHROly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbYHROly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYHROlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:41:47 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61888 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752762AbYHROlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:41:46 -0400
Date: Mon, 18 Aug 2008 15:41:23 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: David Fries <david@fries.net>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
In-Reply-To: <20080818132559.GA19578@elte.hu>
Message-ID: <Pine.LNX.4.55.0808181540400.29123@cliff.in.clinika.pl>
References: <20080818040340.GB17528@spacedout.fries.net>
 <Pine.LNX.4.55.0808180510480.26857@cliff.in.clinika.pl>
 <20080818125803.GC17528@spacedout.fries.net> <20080818132559.GA19578@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, Ingo Molnar wrote:

> the version i committed (reproduced below) should work fine. It uses cr4 
> opportunistically (we get a fault if it does not exist), and we write it 
> back if the cr4 value is non-zero. (which it must always be on a 
> CR4-enabled processor)
> 
> agreed?

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

  Maciej
