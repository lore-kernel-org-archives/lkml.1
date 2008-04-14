Return-Path: <linux-kernel-owner+w=401wt.eu-S1764181AbYDNRrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764181AbYDNRrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762981AbYDNRqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:46:51 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:1286 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761460AbYDNRqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:46:50 -0400
To: Peter Zijlstra <peterz@infradead.org>
Cc: Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
From: Andi Kleen <andi@firstfloor.org>
References: <20080411210022.GJ11962@parisc-linux.org>
	<1208003081.7427.7.camel@twins>
	<20080412172606.GL11962@parisc-linux.org> <adaskxqrgsl.fsf@cisco.com>
	<20080412204748.GN11962@parisc-linux.org>
	<20080413070833.GC19773@elte.hu>
	<20080413125758.GQ11962@parisc-linux.org>
	<20080414153928.GA22259@elte.hu> <adafxtoqvgh.fsf@cisco.com>
	<1208190749.7375.10.camel@twins>
Date: Mon, 14 Apr 2008 19:46:20 +0200
In-Reply-To: <1208190749.7375.10.camel@twins> (Peter Zijlstra's message of "Mon, 14 Apr 2008 18:32:28 +0200")
Message-ID: <87d4osuy6r.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Apr 2008 17:39:34.0680 (UTC) FILETIME=[80E31180:01C89E56]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
>
> Yeah, I would open code it.  But this is indeed a sane usage of the
> counting semaphore because there is no priority inversion.

But when you open code that, how is it different from just having
semaphores? 

-Andi
