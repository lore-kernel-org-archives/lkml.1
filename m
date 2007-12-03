Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbXLCTcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbXLCTcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 14:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbXLCTb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 14:31:56 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:47104 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbXLCTbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 14:31:55 -0500
Subject: Re: [PATCH] isapnp driver semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org
In-Reply-To: <20071203201159.365d49d8@hammerfall>
References: <20071203153743.119714913@mvista.com>
	 <20071203155753.GA32546@elte.hu>
	 <1196697144.1568.1.camel@jnielson-xp.ddns.mvista.com>
	 <20071203164751.GB16135@elte.hu>
	 <1196706902.1568.11.camel@jnielson-xp.ddns.mvista.com>
	 <20071203201159.365d49d8@hammerfall>
Content-Type: text/plain
Date: Mon, 03 Dec 2007 11:20:33 -0800
Message-Id: <1196709633.1568.12.camel@jnielson-xp.ddns.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-03 at 20:11 +0100, Michal Schmidt wrote:
> Dne Mon, 03 Dec 2007 10:35:01 -0800
> Daniel Walker <dwalker@mvista.com> napsal(a):
> 
> > Speaking of automating.. I created a little .vimrc add-on which helps
> > doing sem2mutex type changes. Here's the chunk I added,
> > 
> >     function Semtomutex( lo )
> >         exe '%s/down(&'.a:lo.')/mutex_lock\(\&'.a:lo.'\)/g'
> >         exe '%s/down_trylock(&'.a:lo.')/mutex_trylock\(\&'.a:lo.'\)/g'
> 
> From the comment above mutex_trylock():
>  * NOTE: this function follows the spin_trylock() convention, so
>  * it is negated to the down_trylock() return values! Be careful
>  * about this when converting semaphore users to mutexes.
> 
> Michal

Thanks, I didn't notice this .. I've only run into one tho..

Daniel

