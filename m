Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbXLCTSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbXLCTSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 14:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXLCTSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 14:18:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbXLCTSY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 14:18:24 -0500
Date: Mon, 3 Dec 2007 20:11:59 +0100
From: Michal Schmidt <mschmidt@redhat.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org
Subject: Re: [PATCH] isapnp driver semaphore to mutex
Message-ID: <20071203201159.365d49d8@hammerfall>
In-Reply-To: <1196706902.1568.11.camel@jnielson-xp.ddns.mvista.com>
References: <20071203153743.119714913@mvista.com>
	<20071203155753.GA32546@elte.hu>
	<1196697144.1568.1.camel@jnielson-xp.ddns.mvista.com>
	<20071203164751.GB16135@elte.hu>
	<1196706902.1568.11.camel@jnielson-xp.ddns.mvista.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Mon, 03 Dec 2007 10:35:01 -0800
Daniel Walker <dwalker@mvista.com> napsal(a):

> Speaking of automating.. I created a little .vimrc add-on which helps
> doing sem2mutex type changes. Here's the chunk I added,
> 
>     function Semtomutex( lo )
>         exe '%s/down(&'.a:lo.')/mutex_lock\(\&'.a:lo.'\)/g'
>         exe '%s/down_trylock(&'.a:lo.')/mutex_trylock\(\&'.a:lo.'\)/g'

>From the comment above mutex_trylock():
 * NOTE: this function follows the spin_trylock() convention, so
 * it is negated to the down_trylock() return values! Be careful
 * about this when converting semaphore users to mutexes.

Michal
